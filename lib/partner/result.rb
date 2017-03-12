module Partner
  class Result
    def initialize
      @given_options = {}
      @arguments = []
      @option_values = {}
    end

    def add_option(option_instance:, value:)
      @option_values[option_instance.canonical_name] ||= option_instance.value_wrapper
      @option_values[option_instance.canonical_name].update(value)
      @given_options[option_instance.canonical_name] = true
    end

    def option_values
      @option_values.keys.reduce({}) do |acc, key|
        acc[key] = @option_values[key].raw
        acc
      end
    end

    def add_argument(value:)
      @arguments << value
    end
  end
end
