require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class CombinedShortOptions < Base
      def process(token)
        split_into_short_options(token).each do |short_option_token|
          option_instance = parsing_context.config.find_option_by_short(short_option_token)
          parsing_context.result.add_option(option_instance: option_instance, value: true)
        end
      end

      private

      def split_into_short_options(token)
        token[1, token.length].split("").map{|v| "-#{v}"}
      end
    end
  end
end
