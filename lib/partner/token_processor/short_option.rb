require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class ShortOption < Base
      def process(token)
        option_instance = parsing_context.config.find_option_by_short(token)

        if option_instance
          if option_instance.requires_argument?
            if parsing_context.token_iterator.has_next?
              parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: parsing_context.token_iterator.next)
            else
              # this means input is invalid and should be handled appropriately e.g. raise error
            end
          else
            parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: true)
          end
        else
          # this means input is invalid and should be handled appropriately e.g. raise error
        end
      end
    end
  end
end
