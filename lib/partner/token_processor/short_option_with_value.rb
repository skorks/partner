require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class ShortOptionWithValue < Base
      def process(token)
        option_instance = parsing_context.config.find_option_by_short(token.slice(0,2))
        parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: token.slice(2, token.length))
      end
    end
  end
end
