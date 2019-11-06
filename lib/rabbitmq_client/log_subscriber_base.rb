# frozen_string_literal: true

module RabbitmqClient
  # Log Subscriber base class
  class LogSubscriberBase < ActiveSupport::LogSubscriber
    class << self
      def logger
        @logger ||= RabbitmqClient.logger
      end
    end

    def logger
      LogSubscriberBase.logger
    end
  end
end
