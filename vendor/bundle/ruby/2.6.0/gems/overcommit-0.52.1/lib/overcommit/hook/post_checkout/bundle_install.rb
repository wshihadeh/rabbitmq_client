# frozen_string_literal: true

require 'overcommit/hook/shared/bundle_install'

module Overcommit::Hook::PostCheckout
  # Runs `bundle install` when a change is detected in the repository's
  # dependencies.
  #
  # @see Overcommit::Hook::Shared::BundleInstall
  class BundleInstall < Base
    include Overcommit::Hook::Shared::BundleInstall
  end
end
