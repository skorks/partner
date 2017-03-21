require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class NegatedLongOption < Base
      def process(token)
        option_instance = parsing_context.config.find_option(OptionUtils.long_name_from_negated_long_name(token))

        raise UnknownOptionError.new(token) unless option_instance
        raise InvalidOptionNegationError.new(token) unless option_instance.type.kind_of?(OptionTypes::BooleanType)

        parsing_context.result.add_option(option_instance: option_instance, value: false)
      end
    end
  end
end
