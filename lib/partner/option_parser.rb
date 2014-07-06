require 'partner/token_iterator'
require 'partner/token_classifier'
require 'partner/option_parser_result'
require 'partner/option'

module Partner
  class OptionParser
    attr_reader :option_template_library

    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def parse(tokens = [])
      ::Partner.logger.debug "#{self.class.name} parse start"

      result = OptionParserResult.new
      result.add_options(options_with_default_values)

      token_iterator = TokenIterator.new(tokens)
      while token = token_iterator.next do
        token_classifier = TokenClassifier.new(option_template_library)
        if token_classifier.option_token?(token)
          option_factory = token_classifier.option_factory_for(token, token_iterator)
          option = option_factory.build
          result.add_option(option)
        else
          result.add_leftover(token)
        end
      end

      ::Partner.logger.debug "#{self.class.name} parse end"
      result
    end

    private

    def options_with_default_values
      options = []
      option_template_library.each do |option_template|
        if option_template.default_value
          options << ::Partner::Option.new(option_template)
        end
      end
      options
    end
  end
end
