# frozen_string_literal: true

module RabbitmqClient
  # ExchangeRegistry is a store for all managed exchanges and their details
  class MessagePublisher
    # Custom error is thrown when rabbitmq do not confirm publishing an event
    class ConfirmationFailed < StandardError
      def initialize(exchange, nacked, unconfirmed)
        msg = 'Message confirmation on the exchange ' \
              "#{exchange} has failed (#{nacked}/#{unconfirmed})."
        super(msg)
      end
    end

    def initialize(data, exchange, channel, options)
      @data = data.to_json
      @exchange = exchange
      @channel = channel
      @options = { headers: {} }.merge(options)
      @options[:headers][:tags] = TagsFilter.tags
    end

    def publish
      exchange = @exchange.create(@channel)

      notify('publishing_message')
      exchange.publish(@data, **@options)
      notify('published_message')
    end

    def wait_for_confirms
      notify('confirming_message')
      if @channel.wait_for_confirms
        notify('message_confirmed')
        return
      end
      raise ConfirmationFailed.new(@exchange.name, @channel.nacked_set,
                                   @channel.unconfirmed_set)
    end

    private

    def notify(event)
      ActiveSupport::Notifications.instrument(
        "#{event}.rabbitmq_client",
        message_payload
      )
    end

    def message_payload
      {
        exchange: @exchange.name,
        message_id: @options[:message_id]
      }
    end
  end
end
