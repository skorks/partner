require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class NegatedLongOption < Base
      def process(token)
        option_instance = parsing_context.config.find_option_by_long(OptionUtils.long_name_from_negated_long_name(token))

        if option_instance
          parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: false)
        else
          # this means input is invalid and should be handled appropriately e.g. raise error
        end
      end
    end
  end
end
