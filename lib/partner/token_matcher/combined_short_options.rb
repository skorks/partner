require "partner/token_matcher/base"
require "partner/option_utils"

module Partner
  module TokenMatcher
    class CombinedShortOptions < Base
      def matches?(token)
        /^-[a-zA-Z0-9]{2,}$/.match(token) &&
        valid_short_options?(OptionUtils.split_into_short_options(token))
      end

      private

      def valid_short_options?(list)
        list.all? { |short_options_token| config.find_option(short_options_token) }
      end
    end
  end
end
