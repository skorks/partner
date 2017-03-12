require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class LongOptionWithValueViaEquals < Base
      def process(token)
        long_option_token, value = *token.split("=")
        option_instance = parsing_context.config.find_option_by_long(long_option_token)
        if option_instance
          if option_instance.requires_argument?
            parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: value)
          else
            # this means input is invalid and should be handled appropriately e.g. raise error
          end
        else
          # this means input is invalid and should be handled appropriately e.g. raise error
        end
      end
    end
  end
end
