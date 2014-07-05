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
      ::Partner.logger.debug "#{self.class.name} parse start"

      result = OptionParserResult.new
      token_iterator = TokenIterator.new(tokens)
      while token = token_iterator.next do
        ::Partner.logger.debug token
        token_type = TokenClassifier.new.determine_type(token)
        ::Partner.logger.debug token_type
        if TokenClassifier::OPTION_TOKEN_TYPES.include?(token_type)
          option_factory = OptionFactory.create_for(token_type)
          option = option_factory.build(token, token_iterator)
          result.add_option(option)
          #result.add_option(OptionFactory.new(token_type).build(token, token_iterator))
        else
          result.add_leftover(token)
        end
      end

      ::Partner.logger.debug "#{self.class.name} parse end"
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
