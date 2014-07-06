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

    def add_leftover(leftover)
      @leftovers << leftover
    end

    def add_leftovers(leftovers)
      @leftovers + [leftovers].flatten
    end
  end
end
