module Partner
  class OptionParserResult
    def initialize
      @options = {}
      @leftovers = []
    end

    def options
      @options.values
    end

    def add_option(option)
      @options[option.name] = option
    end

    def add_options(options)
      options.each do |option|
        add_option(option)
      end
    end

    def add_lefover(leftover)
      @leftovers << leftover
    end
  end
end
