require "partner/token_matcher/base"

module Partner
  module TokenMatcher
    class Terminator < Base
      def matches?(token)
        token == "--"
      end
    end
  end
end
