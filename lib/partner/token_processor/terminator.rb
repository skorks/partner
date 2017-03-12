require "partner/token_processor/base"
require "partner/token_processor/argument"

module Partner
  module TokenProcessor
    class Terminator < Base
      def process(token)
        parsing_context.lock_token_type(token_processor_class: Argument)
      end
    end
  end
end
