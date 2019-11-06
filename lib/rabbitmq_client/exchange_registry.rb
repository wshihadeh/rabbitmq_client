# frozen_string_literal: true

require_relative 'exchange'

module RabbitmqClient
  # ExchangeRegistry is a store for all managed exchanges and their details
  class ExchangeRegistry
    # Custom Eroor thrown when trying to find unkown exchange
    class ExchangeNotFound < StandardError
      def initialize(name)
        super("The Exchange '#{name}' cannot be found")
      end
    end

    def initialize
      @exchanges = {}
    end

    def add(name, type, options = {})
      @exchanges[name] = Exchange.new(name, type, options)
    end

    def find(name)
      @exchanges.fetch(name) do
        ActiveSupport::Notifications.instrument(
          'exhange_not_found.rabbitmq_client',
          name: name
        )
        raise ExchangeNotFound, name
      end
    end
  end
end
