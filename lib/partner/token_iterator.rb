module Partner
  class TokenIterator
    attr_reader :args

    def initialize(args:)
      @args = args
      @next_token_position = 0
    end

    def next
      token = args[@next_token_position]
      @next_token_position += 1
      token
    end

    def has_next?
      @next_token_position < args.length
    end
  end
end
