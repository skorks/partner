require 'partner/option_factory/long_option'
module Partner
  class TokenClassifier
    OPTION_TOKEN_TYPES = [:long_option]
    TOKEN_TYPES = OPTION_TOKEN_TYPES

    attr_reader :option_template_library

    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def option_token?(token)
      true
    end

    def option_factory_for(token, token_iterator)
      OptionFactory::LongOption.new(option_template_library, token, token_iterator)
    end

    def token_type(token)
      :long_option
    end
  end
end
