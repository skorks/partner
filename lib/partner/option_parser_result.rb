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
      if option.template.multi
        existing_option = @options[option.name]
        if existing_option && existing_option.given?
          existing_option.value += option.value
        else
          @options[option.name] = option
        end
      else
        @options[option.name] = option
      end
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
