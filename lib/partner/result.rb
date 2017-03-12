module Partner
  class Result
    def initialize
      @given_options = {}
      @arguments = []
    end

    def add_option(canonical_name:, value:)
      @given_options[canonical_name] = value
    end

    def add_argument(value:)
      @arguments << value
    end
  end
end
