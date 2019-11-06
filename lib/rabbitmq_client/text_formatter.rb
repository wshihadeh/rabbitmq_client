# frozen_string_literal: true

require 'json'
require 'English'

module RabbitmqClient
  # Formatter for text log messages
  class TextFormatter < ::Logger::Formatter
    def initialize
      @datetime_format = nil
      @severity_text = nil
      @tags = nil
      super
    end

    def call(severity, time, progname, msg)
      create_instance_vars(severity)
      format(Format,
             @severity_text[0],
             format_datetime(time),
             $PID,
             @severity_text,
             progname,
             "#{@tags}#{msg2str(msg)}")
    end

    private

    def create_instance_vars(severity)
      @severity_text = if severity.is_a?(Integer)
                         Logger::Severity.constants(false).select do |level|
                           Logger::Severity.const_get(level) == severity
                         end.first.to_s
                       else
                         severity
                       end
      @tags = (TagsFilter.tags || {}).collect do |key, val|
        "[#{key}: #{val}] "
      end.join
    end
  end
end
