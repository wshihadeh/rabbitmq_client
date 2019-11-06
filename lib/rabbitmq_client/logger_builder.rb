# frozen_string_literal: true

module RabbitmqClient
  # ExchangeRegistry is a store for all managed exchanges and their details
  class LoggerBuilder
    def initialize(config)
      @logger = config[:logger].clone
      @format = config[:logs_format]
      @level = config[:logs_level].to_sym
      @filename = config[:logs_filename]
    end

    def build_logger
      @logger ||= ::Logger.new(@filename || STDOUT)
      @logger.level = @level
      @logger.formatter = create_logger_formatter
      log_subscriber.attach_to(:rabbitmq_client)
      @logger
    end

    private

    def create_logger_formatter
      json? ? JsonFormatter.new : TextFormatter.new
    end

    def log_subscriber
      json? ? JsonLogSubscriber : PlainLogSubscriber
    end

    def json?
      __method__.to_s == "#{@format}?"
    end
  end
end
