require "partner/token_matcher/base"
require "partner/option_utils"

module Partner
  module TokenMatcher
    class ShortOptionWithValue < Base
      def matches?(token)
        /^-[a-zA-Z0-9]{1}[a-zA-Z0-9_-]+$/.match(token) &&
        valid_short_options?(OptionUtils.split_into_short_options(token)[0..0]) &&
        !valid_short_options?(OptionUtils.split_into_short_options(token)[1..-1])
      end

      private

      def valid_short_options?(list)
        list.all? { |short_options_token| config.find_option(short_options_token) }
      end
    end
  end
end
