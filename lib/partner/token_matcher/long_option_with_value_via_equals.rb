require "partner/token_matcher/base"
require "partner/token_matcher/terminator"

module Partner
  module TokenMatcher
    class LongOptionWithValueViaEquals < Base
      def matches?(token)
        token.start_with?("--") &&
        !token.start_with?("--no-") &&
        !Terminator.new(config: config, result: result).matches?(token) &&
        token.include?("=")
      end
    end
  end
end