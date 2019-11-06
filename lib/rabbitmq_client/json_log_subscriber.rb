# frozen_string_literal: true

require_relative 'log_subscriber_base'

module RabbitmqClient
  # Manage RabbitmqClient plain text logs
  class JsonLogSubscriber < LogSubscriberBase
    def publisher_created(event)
      debug(action: 'publisher_created',
            message: 'The RabbitmqClient publisher is created',
            publisher_configs: event.payload)
    end

    def network_error(event)
      payload = event.payload
      error({ action: 'network_error',
              message: 'Failed to publish a message',
              error_message: payload.fetch(:error).message }.merge(
                process_payload(payload)
              ))
    end

    def overriding_configs(event)
      debug(action: 'overriding_configs',
            message: 'Overriding publisher configs',
            publisher_configs: event.payload)
    end

    def publishing_message(event)
      debug({ action: 'publishing_message',
              message: 'Publishing a new message' }.merge(
                process_payload(event.payload)
              ))
    end

    def published_message(event)
      info({ action: 'published_message',
             message: 'Published a message' }.merge(
               process_payload(event.payload)
             ))
    end

    def confirming_message(event)
      debug({ action: 'confirming_message',
              message: 'Confirming a message' }.merge(
                process_payload(event.payload)
              ))
    end

    def message_confirmed(event)
      debug({ action: 'message_confirmed',
              message: 'Confirmed a message' }.merge(
                process_payload(event.payload)
              ))
    end

    def exhange_not_found(event)
      error(action: 'exhange_not_found',
            message: 'Exhange Not Found',
            exchange_name: event.payload.fetch(:name))
    end

    def created_exhange(event)
      debug(action: 'created_exhange',
            message: 'Exhange is created successfuly',
            exchange_name: event.payload.fetch(:name))
    end

    private

    %w[info debug warn error fatal unknown].each do |level|
      class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{level}(progname = nil, &block)
          logger.#{level} rabbitmq_client_event(progname, &block) if logger
        end
      METHOD
    end

    def rabbitmq_client_event(event)
      { source: 'rabbitmq_client' }.merge(event)
    end

    def process_payload(payload)
      {
        exchange_name: payload.fetch(:exchange, 'undefined'),
        message_id: payload.fetch(:message_id, 'undefined')
      }
    end
  end
end
