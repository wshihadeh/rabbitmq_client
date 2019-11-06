# frozen_string_literal: true

require 'active_support/core_ext/class/attribute'

module RabbitmqClient
  # Custom Error thrown in case of defining a plugin without any callbacks
  class EmptyPlugin < RuntimeError
    def initialize(name)
      super("The Plugin '#{name}' is empty")
    end
  end
  # Plugin class is the base class for all Plugins that
  # extends RabbitmqClient functionalty.
  class Plugin
    def initialize
      callback_block.call(RabbitmqClient.lifecycle)
    end

    def callback_block
      klass = self.class
      klass.callback_block || (raise EmptyPlugin, klass.to_s)
    end

    class << self
      attr_accessor :callback_block
      def callbacks(&block)
        @callback_block = block
      end
    end
  end
end
