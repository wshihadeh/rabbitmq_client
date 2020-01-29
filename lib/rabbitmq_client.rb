# frozen_string_literal: true

require 'active_support'
require 'bunny'
require 'connection_pool'

require 'rabbitmq_client/version'
require 'rabbitmq_client/lifecycle'
require 'rabbitmq_client/plugin'
require 'rabbitmq_client/exchange_registry'
require 'rabbitmq_client/publisher'

# RabbitmqClient Module is used as a clinet library for Rabbitmq
# This Module is supporting the following use cases
# - Publish events to Rabbitmq server
module RabbitmqClient
  extend ActiveSupport::Autoload

  include ActiveSupport::Configurable
  include ActiveSupport::JSON

  eager_autoload do
    autoload :LoggerBuilder
    autoload :PlainLogSubscriber
    autoload :JsonLogSubscriber
    autoload :JsonFormatter
    autoload :TextFormatter
    autoload :TagsFilter
  end

  @exchange_registry = ExchangeRegistry.new
  # [url] url address of rabbitmq server
  config_accessor(:rabbitmq_url, instance_accessor: false) do
    'amqp://guest:guest@127.0.0.1:5672'
  end

  # [logger_configs] configs for teh used logger
  # logs_format: json, plain
  # logs_to_stdout: true, false
  # logs_level: info, debug
  # logs_filename: logs file name
  config_accessor(:logger_configs, instance_accessor: false) do
    {
      logs_format: 'plain',
      logs_level: :info,
      logs_filename: nil,
      logger: nil
    }
  end
  # default rabbitmq configs
  # heartbeat_publisher = 0
  # session_pool = 1
  # session_pool_timeout = 5
  config_accessor(:session_params, instance_accessor: false) do
    {
      heartbeat_publisher: 0,
      async_publisher: true,
      session_pool: 1,
      session_pool_timeout: 5
    }
  end

  config_accessor(:plugins, instance_accessor: false) { [] }
  config_accessor(:global_store, instance_accessor: false) { nil }
  config_accessor(:whitelist, instance_accessor: false) do
    ['x-request-id'.to_sym]
  end

  class << self
    def add_exchange(name, type, options = {})
      @exchange_registry.add(name, type, options)
    end

    def publish(payload, options = {})
      publisher.publish(payload, options)
    end

    def lifecycle
      @lifecycle ||= setup_lifecycle
    end

    def logger
      @logger ||= setup_logger
    end

    private

    def setup_logger
      LoggerBuilder.new(config[:logger_configs]).build_logger
    end

    def publisher
      @publisher ||= init_publisher
    end

    def init_publisher
      Publisher.new(config.merge(
                      exchange_registry: @exchange_registry
                    ))
    end

    def setup_lifecycle
      @lifecycle = Lifecycle.new
      plugins.each(&:new)
      @lifecycle
    end
  end
end
