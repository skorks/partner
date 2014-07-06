module Partner
  class TokenIterator
    attr_reader :tokens

    def initialize(tokens = [])
      @tokens = tokens || []
      @current_index = 0
    end

    def next
      tokens[@current_index].tap do |token|
        ::Partner.logger.debug "#{self.class.name} fetching next token: #{token}"
        @current_index += 1
      end
    end

    def remaining
      tokens[@current_index..tokens.size]
    end
  end
end
