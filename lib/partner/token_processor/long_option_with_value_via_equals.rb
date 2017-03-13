require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class LongOptionWithValueViaEquals < Base
      def process(token)
        long_option_token, value = *token.split("=")
        option_instance = parsing_context.config.find_option_by_long(long_option_token)

        raise Error::UnknownOptionError.new(token) unless option_instance
        raise Error::InvalidOptionArgumentError.new(token) unless option_instance.requires_argument?

        parsing_context.result.add_option(option_instance: option_instance, value: value)
      end
    end
  end
end