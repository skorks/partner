module Partner
  class ParserResult
    def initialize(options, command, arguments)
      @options = options
      @command = command
      @arguments = arguments
    end

    def options
      @options_hash ||= @options.reduce({}) do |acc, option|
        acc[option.name] = option.value
        acc
      end
    end

    def given_options
      @given_options ||= @options.reduce([]) do |acc, option|
        acc << option.name if option.given?
        acc
      end
    end

    def default_options
      @default_options ||= @options.reduce([]) do |acc, option|
        acc << option.name unless option.given?
        acc
      end
    end

    def command
      @command
    end

    def arguments
      @arguments
    end
  end
end
