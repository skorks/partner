module Partner
  class TokenClassifier
    attr_reader :token

    def initialize(token)
      @token = token
    end

    def option?
      if short_option? ||
        long_option? ||
        negated_long_option?
        true
      else
        false
      end
    end

    def short_option?
      token.start_with?('-') && !token.start_with?('--')
    end

    def long_option?
      token.start_with?('--') && !token.start_with?('--no-') && !terminator?
    end

    def negated_long_option?
      token.start_with?('--no-')
    end

    def terminator?
      token == '--'
    end
  end
end
