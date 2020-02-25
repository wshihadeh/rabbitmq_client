# frozen_string_literal: true

require 'overcommit/hook/shared/yarn_install'

module Overcommit::Hook::PostMerge
  # Runs `yarn install` when a change is detected in the repository's
  # dependencies.
  #
  # @see Overcommit::Hook::Shared::YarnInstall
  class YarnInstall < Base
    include Overcommit::Hook::Shared::YarnInstall
  end
end
