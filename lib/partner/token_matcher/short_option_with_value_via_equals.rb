require "partner/token_matcher/base"
require "partner/token_matcher/terminator"

module Partner
  module TokenMatcher
    class ShortOptionWithValueViaEquals < Base
      def matches?(token)
        token.start_with?('-') &&
        !token.start_with?('--') &&
        token.length > 2 &&
        token.include?("=") &&
        valid_short_options?(split_into_short_options(token)[0..0]) &&
        !valid_short_options?(split_into_short_options(token)[1..-1])
      end

      private

      def split_into_short_options(token)
        token[1, token.length].split("").map{|v| "-#{v}"}
      end

      def valid_short_options?(list)
        list.all? { |short_options_token| config.find_option(short_options_token) }
      end
    end
  end
end
