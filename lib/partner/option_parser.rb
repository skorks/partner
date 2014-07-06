require 'partner/token_iterator'
require 'partner/token_classifier'
require 'partner/option_parser_result'
require 'partner/option'
require 'partner/option_template_finder_factory'
require 'partner/option_factory_builder'

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
        token_classifier = TokenClassifier.new(token)
        if token_classifier.terminator?
          result.add_leftovers(token_iterator.remaining)
          break
        elsif token_classifier.combined_short_options?
          token.gsub(/-/, '').split('').map {|letter| "-#{letter}"}.each do |new_token|
            result.add_option(build_option(new_token, token_iterator))
          end
        elsif token_classifier.option?
          result.add_option(build_option(token, token_iterator))
        else
          result.add_leftover(token)
        end
      end

      ::Partner.logger.debug "#{self.class.name} parse end"
      result
    end

    private

    def build_option(token, token_iterator)
      token_classifier = TokenClassifier.new(token)
      finder = OptionTemplateFinderFactory.new(option_template_library).build(token_classifier)
      option_factory_builder = OptionFactoryBuilder.new(finder, token_classifier)
      option_factory = option_factory_builder.build(token)
      option_factory.build(token_iterator)
    end

    def options_with_default_values
      options = []
      option_template_library.each do |option_template|
        if option_template.default_value != nil
          options << ::Partner::Option.new(option_template)
        end
      end
      options
    end
  end
end
