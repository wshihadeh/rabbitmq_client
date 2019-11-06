# frozen_string_literal: true

module RabbitmqClient
  # Custom error thrown when an unsupported callback type is used
  class InvalidCallback < RuntimeError
    def initialize(name)
      super("The Callback '#{name}' is an invalid callback and cannot be used")
    end
  end

  # Callback Object Store all plugins clallbacks
  # Supported callback types are before and adter
  class Callback
    def initialize
      @before = []
      @after = []
    end

    def execute(*args, &block)
      execute_before_callbacks(*args)
      result = block.call(*args)
      execute_after_callbacks(*args)
      result
    end

    def add(type, &callback)
      case type
      when :before
        @before << callback
      when :after
        @after << callback
      else
        raise InvalidCallback, "Invalid callback type: #{type}"
      end
    end

    private

    def execute_before_callbacks(*args)
      @before.each { |callback| callback.call(*args) }
    end

    def execute_after_callbacks(*args)
      @after.each { |callback| callback.call(*args) }
    end
  end
end
