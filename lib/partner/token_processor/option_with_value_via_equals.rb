require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class OptionWithValueViaEquals < Base
      def process(token)
        option_token, value = *token.split("=")
        option_instance = parsing_context.config.find_option(option_token)

        raise UnknownOptionError.new(token) unless option_instance
        raise InvalidOptionArgumentError.new(token) unless option_instance.requires_argument?

        parsing_context.result.add_option(option_instance: option_instance, value: value)
      end
    end
  end
end
