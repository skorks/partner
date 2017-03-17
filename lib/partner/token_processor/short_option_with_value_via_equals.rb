require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class ShortOptionWithValueViaEquals < Base
      def process(token)
        short_option_token, value = *token.split("=")
        option_instance = parsing_context.config.find_option_by_short(short_option_token)

        raise UnknownOptionError.new(token) unless option_instance
        raise InvalidOptionArgumentError.new(token) unless option_instance.requires_argument?

        parsing_context.result.add_option(option_instance: option_instance, value: value)
      end
    end
  end
end
