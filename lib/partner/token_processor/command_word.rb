require "partner/token_processor/base"
require "partner/error"

module Partner
  module TokenProcessor
    class CommandWord < Base
      def process(token)
        if parsing_context.config.valid_command_word_order?(token, parsing_context.result.command_word_list)
          parsing_context.result.add_command_word(value: token)
        else
          raise InvalidCommandError.new([parsing_context.result.command_word_list, token].flatten.join(" "))
        end
      end
    end
  end
end
