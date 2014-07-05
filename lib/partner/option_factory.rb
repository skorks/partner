module Partner
  class OptionFactory
    attr_reader :token_type

    def initialize(token_type)
      @token_type = token_type
    end

    def build(token, token_iterator)
    end
  end
end
