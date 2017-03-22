require "partner/token_processor/base"
require "partner/option_utils"

module Partner
  module TokenProcessor
    class CombinedShortOptions < Base
      def process(token)
        OptionUtils.split_into_short_options(token).each do |short_option_token|
          option_instance = parsing_context.config.find_option(short_option_token)
          parsing_context.result.add_option(option_instance: option_instance, value: true)
        end
      end
    end
  end
end
