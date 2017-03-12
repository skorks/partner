require "partner/token_matcher/base"

module Partner
  module TokenMatcher
    class CombinedShortOptions < Base
      def matches?(token)
        token.start_with?('-') &&
        !token.start_with?('--') &&
        token.length > 2 &&
        valid_short_options?(split_into_short_options(token))
      end

      private

      def split_into_short_options(token)
        token[1, token.length].split("").map{|v| "-#{v}"}
      end

      def valid_short_options?(list)
        list.all? { |short_options_token| config.find_option_by_short(short_options_token) }
      end
    end
  end
end
