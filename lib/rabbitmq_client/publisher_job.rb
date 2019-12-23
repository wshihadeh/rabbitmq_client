# frozen_string_literal: true

require_relative 'message_publisher'
require 'sucker_punch'

module RabbitmqClient
  # Publisher class is responsible for publishing events to rabbitmq exhanges
  class PublisherJob
    include SuckerPunch::Job

    def perform(registry, session_pool, data, options)
      handle_publish_event(registry, session_pool, data, options)
    rescue StandardError => e
      notify('network_error', error: e, options: options)
      raise
    end

    private

    def handle_publish_event(registry, session_pool, data, options)
      exchange = registry.find(options.fetch(:exchange_name, nil))
      session_pool.with do |session|
        session.start
        channel = session.create_channel
        channel.confirm_select
        message = MessagePublisher.new(data, exchange, channel, options)
        message.publish
        message.wait_for_confirms
        channel.close
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
