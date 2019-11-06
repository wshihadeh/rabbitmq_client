# frozen_string_literal: true

require 'json'

module RabbitmqClient
  # Formatter for json log messages
  class JsonFormatter
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%6N '
    def initialize
      @json = {}
      @msg = ''
    end

    def call(severity, timestamp, progname, msg)
      @json = build_new_json(msg)
      @json = @json.merge(progname: progname.to_s, level: severity,
                          timestamp: timestamp.strftime(TIME_FORMAT))
      @json = @json.reject { |_key, value| value.to_s.empty? }

      @json.to_json + "\n"
    end

    def build_new_json(msg)
      @msg  = msg
      @json = @msg.is_a?(Hash) ? @msg : { message: @msg.strip }
      @json.merge(TagsFilter.tags || {})
    end
  end
end
