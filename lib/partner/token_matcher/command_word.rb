require "partner/token_matcher/base"

module Partner
  module TokenMatcher
    class CommandWord < Base
      def matches?(token)
        config.valid_command_word?(token)
      end
    end
  end
end
