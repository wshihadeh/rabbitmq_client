# frozen_string_literal: true

require 'rubycritic_small_badge/configuration'

# :nodoc:
module RubyCriticSmallBadge
  @configuration = Configuration.new
  def self.configure
    yield config
  end

  def self.config
    @configuration
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'rubycritic_small_badge/version'
require 'rubycritic_small_badge/report'
