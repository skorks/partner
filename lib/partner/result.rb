module Partner
  class Result
    def initialize
      @given_options = {}
      @arguments = []
      @option_values = {}
      @command_word_list = []
    end

    def add_option(option_instance:, value:)
      @option_values[option_instance.canonical_name] ||= option_instance.value_wrapper
      @option_values[option_instance.canonical_name].update(value)
      @given_options[option_instance.canonical_name] = true
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

    def command_word_list
      @command_word_list
    end

    def command
      if @command_word_list.length > 0
        @command_word_list.join(" ")
      else
        nil
      end
    end

    def arguments
      @arguments
    end
  end
end
