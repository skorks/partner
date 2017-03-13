require "partner/token_matcher/base"
require "partner/token_matcher/terminator"

module Partner
  module TokenMatcher
    class ShortOption < Base
      def matches?(token)
        token.start_with?("-") &&
        token.length == 2 &&
        !Terminator.new(config: config, result: result).matches?(token) &&
        !token.include?("=")
      end
    end
  end
end