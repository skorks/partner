require "partner/token_matcher/base"
require "partner/token_matcher/terminator"

module Partner
  module TokenMatcher
    class ShortOptionWithValueViaEquals < Base
      def matches?(token)
        token.start_with?("-") &&
        token.length == 2 &&
        !Terminator.new(config: config).matches?(token) &&
        token.include?("=")
      end
    end
  end
end
