require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class ShortOption < Base
      def process(token)
        option_instance = parsing_context.config.find_option_by_short(token)

        raise UnknownOptionError.new(token) unless option_instance
        raise MissingOptionArgumentError.new(token) if option_instance.requires_argument? && !parsing_context.token_iterator.has_next?

        if option_instance.requires_argument?
          value = parsing_context.token_iterator.next
          parsing_context.result.add_option(option_instance: option_instance, value: value)
        else
          parsing_context.result.add_option(option_instance: option_instance, value: true)
        end
      end
    end
  end
end
