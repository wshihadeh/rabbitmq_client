# frozen_string_literal: true

require 'simplecov'
require 'byebug'
require 'simplecov_small_badge'

SimpleCov.start do
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCovSmallBadge::Formatter
    ]
  )
end

SimpleCov.minimum_coverage 100

require 'rubygems'
require 'bundler/setup'
require 'rubycritic_small_badge'

Dir[File.join('./spec/support/*.rb')].each { |f| require f }

SimpleCovSmallBadge.configure do |config|
  # config.rounded_border = false
end

RSpec.configure do |config|
  # some (optional) config here
end
