module Partner
  class CommandParser
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def parse(tokens)
      CommandParserResult.new
    end
  end

  class CommandParserResult
    attr_accessor :command
    attr_reader :leftovers

    def initialize
      @command = nil
      @leftovers = []
    end

    def add_lefover(leftover)
      leftovers << leftover
    end
  end
end
