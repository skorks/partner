require "partner/token_processor/base"

module Partner
  module TokenProcessor
    class Argument < Base
      def process(token)
        parsing_context.result.add_argument(value: token)
      end
    end
  end
end
