require 'partner/token_iterator'
require 'partner/token_classifier'
require 'partner/option_factory'

module Partner
  class OptionParser
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def parse(tokens = [])
      result = OptionParserResult.new
      token_iterator = TokenIterator.new(tokens)
      while token = token_iterator.next do
        token_type = TokenClassifier.new.determine_type(token)
        if TokenClassifier::OPTION_TOKEN_TYPES.include?(token_type)
          result.add_option(OptionFactory.new(token_type).build(token, token_iterator))
        else
          result.add_leftover(token)
        end
      end
      result
    end
  end

  class OptionParserResult
    attr_reader :options, :leftovers

    def initialize
      @options = []
      @leftovers = []
    end

    def add_option(option)
      options << option
    end

    def add_lefover(leftover)
      leftovers << leftover
    end
  end
end
