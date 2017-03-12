require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class NegatedLongOption < Base
      def process(token)
        option_instance = parsing_context.config.find_option_by_long(OptionUtils.long_name_from_negated_long_name(token))

        raise Error::UnknownOptionError.new(token) unless option_instance

        parsing_context.result.add_option(option_instance: option_instance, value: false)
      end
    end
  end
end
