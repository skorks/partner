module Partner
  class TokenClassifier
    OPTION_TOKEN_TYPES = [:long_option]
    TOKEN_TYPES = OPTION_TOKEN_TYPES

    def determine_type(token)
      :long_option
    end
  end
end
