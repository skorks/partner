require "partner/token_matcher/base"

module Partner
  module TokenMatcher
    class NegatedLongOption < Base
      def matches?(token)
        token.start_with?('--no-')
      end
    end
  end
end
