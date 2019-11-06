# frozen_string_literal: true

module RabbitmqClient
  # ExchangeRegistry is a store for all managed exchanges and their details
  class TagsFilter
    def self.tags
      config = RabbitmqClient.config
      global_store = config.global_store
      return unless global_store

      global_store.store.select do |key, _value|
        Array(config.whitelist).include? key.downcase.to_sym
      end
    end
  end
end
