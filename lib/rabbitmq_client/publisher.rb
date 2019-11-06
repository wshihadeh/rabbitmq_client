# frozen_string_literal: true

require_relative 'message_publisher'

module RabbitmqClient
  # Publisher class is responsible for publishing events to rabbitmq exhanges
  class Publisher
    def initialize(**config)
      @config = config
      @session_params = session_params
      @exchange_registry = @config.fetch(:exchange_registry, nil)
      @session_params.freeze
      @session_pool = create_connection_pool
      notify('publisher_created', @session_params)
    end

    def publish(data, options)
      return nil unless @exchange_registry

      handle_publish_event(data, options)
    rescue StandardError => e
      notify('network_error', error: e, options: options)
      raise
    end

    private

    def overwritten_config_notification
      return unless overwritten_config?

      notify('overriding_configs',
             threaded: false,
             automatically_recover: false)
    end

    def overwritten_config?
      @config.dig(:session_params, :threaded) ||
        @config.dig(:session_params, :automatically_recover)
    end

    def session_params
      overwritten_config_notification
      @config.fetch(:session_params, {})
             .merge(threaded: false,
                    automatically_recover: false,
                    heartbeat: @config.dig(
                      :session_params, :heartbeat_publisher
                    ) || 0)
    end

    def handle_publish_event(data, options)
      exchange = @exchange_registry.find(options.fetch(:exchange_name, nil))
      @session_pool.with do |session|
        session.start
        channel = session.create_channel
        channel.confirm_select
        message = MessagePublisher.new(data, exchange, channel, options)
        message.publish
        message.wait_for_confirms
        channel.close
      end
    end

    def create_connection_pool
      pool_size = @session_params.fetch(:session_pool, 1)
      ConnectionPool.new(size: pool_size) do
        Bunny.new(@config[:rabbitmq_url],
                  { logger: RabbitmqClient.logger }.merge(@session_params))
      end
    end

    def notify(event, payload = {})
      ActiveSupport::Notifications.instrument(
        "#{event}.rabbitmq_client",
        payload
      )
    end
  end
end
