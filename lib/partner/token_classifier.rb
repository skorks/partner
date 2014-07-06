require 'partner/option_factory/long_option'
require 'partner/option_factory/short_option'

module Partner
  class TokenClassifier
    #OPTION_TOKEN_TYPES = [:long_option]
    #TOKEN_TYPES = OPTION_TOKEN_TYPES

    attr_reader :option_template_library

    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def option_token?(token)
      if !terminator_token?(token) &&
        (token.start_with?('-') || token.start_with?('--'))
        true
      else
        false
      end
    end

    def terminator_token?(token)
      token == '--'
    end

    def option_factory_for(token, token_iterator)
      if token.start_with?('-') && !token.start_with?('--')
        OptionFactory::ShortOption.new(option_template_library, token, token_iterator)
      elsif token.start_with?('--')
        OptionFactory::LongOption.new(option_template_library, token, token_iterator)
      end
    end

    #def token_type(token)
      #:long_option
    #end
  end
end
