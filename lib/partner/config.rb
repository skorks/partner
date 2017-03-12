module Partner
  class Config
    def initialize
      @options_by_canonical_name = {}
      @options_by_short = {}
      @options_by_long = {}
    end

    def add_option(option)
      @options_by_canonical_name[option.canonical_name] = option
      @options_by_long[option.long] = option
      @options_by_short[option.short] = option if option.short
    end

    def add_command(command_string)
    end

    def find_option_by_long(token)
      @options_by_long[token]
    end

    def find_option_by_short(token)
      @options_by_short[token]
    end
  end
end
