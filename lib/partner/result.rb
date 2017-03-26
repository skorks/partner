require "partner/option_value"
require "partner/option_handler/terminating_string_handler"

module Partner
  class Result
    attr_reader :arguments, :given_options, :command_word_list

    def initialize
      @given_options = {}
      @arguments = []
      @option_values = {}
      @command_word_list = []
    end

    def add_option(option_instance:, value:)
      @option_values[option_instance.canonical_name] ||= OptionValue.new(option_instance.type)
      @option_values[option_instance.canonical_name].update(value)
      @given_options[option_instance.canonical_name] = true

      ExecuteOptionHandler.new(
        option_instance: option_instance,
        option_value: @option_values[option_instance.canonical_name].raw
      ).execute
    end

    def add_option_default(option_instance:)
      @option_values[option_instance.canonical_name] ||= OptionValue.new(option_instance.type)
      @option_values[option_instance.canonical_name].update(option_instance.default)
    end

    def add_argument(value:)
      @arguments << value
    end

    def add_command_word(value:)
      @command_word_list << value.strip
    end

    def option_values
      @option_values.keys.reduce({}) do |acc, key|
        acc[key] = @option_values[key].raw
        acc
      end
    end

    def command
      if @command_word_list.length > 0
        @command_word_list.join(" ")
      else
        nil
      end
    end

    def option_has_value?(option_instance:)
      @option_values[option_instance.canonical_name]
    end

    def option_given?(option_instance:)
      @given_options[option_instance.canonical_name]
    end

    def to_h
      {
        command: command,
        options: option_values,
        arguments: arguments,
        given_options: given_options,
      }
    end

    class ExecuteOptionHandler
      attr_reader :option_instance, :option_value

      def initialize(option_instance:, option_value:)
        @option_instance = option_instance
        @option_value = option_value
      end

      def execute
        return unless option_instance.handler

        handler = possible_handler
        handler_data = option_value

        if possible_handler.kind_of?(String)
          handler_data = possible_handler
          handler = Partner::OptionHandler::TerminatingStringHandler.new
        elsif possible_handler.kind_of?(Class)
          handler = possible_handler.new
        end

        handler.execute(data: handler_data, option_instance: option_instance)
        exit(0) if handler.terminating?
      end

      private

      def possible_handler
        option_instance.handler
      end
    end
  end
end
