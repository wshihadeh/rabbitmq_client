# frozen_string_literal: true

require 'overcommit/hook/shared/npm_install'

module Overcommit::Hook::PostCheckout
  # Runs `npm install` when a change is detected in the repository's
  # dependencies.
  #
  # @see Overcommit::Hook::Shared::NpmInstall
  class NpmInstall < Base
    include Overcommit::Hook::Shared::NpmInstall
  end
end
