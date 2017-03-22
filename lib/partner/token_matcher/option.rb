require "partner/token_matcher/base"

module Partner
  module TokenMatcher
    class Option < Base
      def matches?(token)
        /^--(?!no-)[a-zA-Z0-9]+[a-zA-Z0-9_-]*$|^-[a-zA-Z0-9]{1}$/.match(token)
      end
    end
  end
end
