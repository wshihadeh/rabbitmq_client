# frozen_string_literal: true

require_relative 'log_subscriber_base'

module RabbitmqClient
  # Manage RabbitmqClient plain text logs
  class PlainLogSubscriber < LogSubscriberBase
    def publisher_created(event)
      msg = 'The RabbitmqClient publisher is created ' \
            "with the follwong configs #{event.payload.inspect}"
      debug(msg)
    end

    def network_error(event)
      payload = event.payload
      msg = "Failed to publish a message (#{payload.fetch(:error).message}) " \
            "to exchange (#{payload.dig(:options, :exchange_name)})"
      error(msg)
    end

    def overriding_configs(event)
      msg = 'Overriding the follwing configs for ' \
            "the created publisher #{event.payload.inspect}"
      debug(msg)
    end

    def publishing_message(event)
      payload = event.payload
      msg = 'Start>> Publishing a new message ' \
            "(message_id: #{payload.fetch(:message_id, 'undefined')} ) " \
            "to the exchange (#{payload.fetch(:exchange, 'undefined')})"
      debug(msg)
    end

    def published_message(event)
      payload = event.payload
      msg = '<<DONE Published a message to ' \
           "the exchange (#{payload.fetch(:exchange, 'undefined')}) " \
           "with message_id: #{payload.fetch(:message_id, 'undefined')}"
      info(msg)
    end

    def confirming_message(event)
      msg = 'Start>> confirming a message ' \
            "(message_id: #{event.payload.fetch(:message_id, 'undefined')})"
      debug(msg)
    end

    def message_confirmed(event)
      msg_id = event.payload.fetch(:message_id, 'undefined')
      msg = '<<DONE confirmed a message ' \
            "(message_id: #{msg_id}) Successfuly"
      debug(msg)
    end

    def exhange_not_found(event)
      error("The Exchange '#{event.payload.fetch(:name)}' cannot be found")
    end

    def created_exhange(event)
      debug("The #{event.payload.fetch(:name)} exchange is created successfuly")
    end
  end
end
