# frozen_string_literal: true

module RabbitmqClient
  # ExchangeRegistry is a store for all managed exchanges and their details
  class Exchange
    attr_reader :name, :type, :options

    def initialize(name, type, options)
      @name = name
      @type = type
      @options = options
    end

    def create(channel)
      exhange_obj = Bunny::Exchange.new(channel, @type, @name,
                                        @options)
      ActiveSupport::Notifications.instrument(
        'created_exhange.rabbitmq_client',
        name: @name,
        type: @type
      )
      exhange_obj
    end
  end
end
