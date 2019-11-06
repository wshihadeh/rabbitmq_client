# frozen_string_literal: true

require_relative 'callback'

module RabbitmqClient
  # Lifecycle defines the rabbitmq_client lifecycle events,
  # callbacks and manage the  execution of these callbacks
  class Lifecycle
    EVENTS = {
      publish: %i[message options]
    }.freeze

    attr_reader :callbacks

    def initialize
      @callbacks = EVENTS.keys.each_with_object({}) do |key, hash|
        hash[key] = Callback.new
      end
    end

    def before(event, &block)
      add(:before, event, &block)
    end

    def after(event, &block)
      add(:after, event, &block)
    end

    def run_callbacks(event, *args, &block)
      missing_callback(event) unless @callbacks.key?(event)
      event_obj = EVENTS[event]
      event_size = event_obj.size

      unless event_size == args.size
        raise ArgumentError, "Callback #{event} expects\
         #{event_size} parameter(s): #{event_obj.join(', ')}"
      end

      @callbacks[event].execute(*args, &block)
    end

    private

    def add(type, event, &block)
      missing_callback(event) unless @callbacks.key?(event)
      @callbacks[event].add(type, &block)
    end

    def missing_callback(event)
      raise InvalidCallback, "Unknown callback event: #{event}"
    end
  end
end
