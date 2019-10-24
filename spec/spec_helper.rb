# frozen_string_literal: true

require 'simplecov'
require 'simplecov_small_badge'
require 'byebug'
require 'timecop'

SimpleCov.start do
  add_filter '/spec/'

  module SimpleCovSmallBadge
    class Formatter
    end
  end

  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCovSmallBadge::Formatter
    ]
  )
end

SimpleCov.minimum_coverage 100

require 'rubygems'
require 'bundler/setup'

require 'rabbitmq_client'

Dir[File.join('./spec/support/*.rb')].each { |f| require f }

SimpleCovSmallBadge.configure do |config|
  config.rounded_border = true
end

RSpec.configure do |config|
end
