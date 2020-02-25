# frozen_string_literal: true

module Overcommit::Hook::PreCommit
  # Runs `semistandard` against any modified JavaScript files.
  #
  # @see https://github.com/Flet/semistandard
  class SemiStandard < Base
    MESSAGE_REGEX = /^\s*(?<file>(?:\w:)?[^:]+):(?<line>\d+)/

    def run
      result = execute(command, args: applicable_files)
      output = result.stdout.chomp
      return :pass if result.success? && output.empty?

      # example message:
      #   path/to/file.js:1:1: Error message (ruleName)
      extract_messages(
        output.split("\n").grep(MESSAGE_REGEX), # ignore header line
        MESSAGE_REGEX
      )
    end
  end
end
