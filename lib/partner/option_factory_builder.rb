require 'partner/option_factory/string_option'
require 'partner/option_factory/boolean_option'
require 'partner/option_factory/negated_boolean_option'

module Partner
  class OptionFactoryBuilder
    attr_reader :finder, :token_classifier

    def initialize(finder, token_classifier)
      @finder = finder
      @token_classifier = token_classifier
    end

    def build(token)
      template = finder.find_template_for(token)
      ensure_only_boolean_options_can_be_negated(token, template)

      if template.type == :boolean && token_classifier.negated_long_option?
        OptionFactory::NegatedBooleanOption.new(template)
      elsif template.type == :boolean
        OptionFactory::BooleanOption.new(template)
      elsif template.type == :string
        OptionFactory::StringOption.new(template)
      end
    end

    private

    def ensure_only_boolean_options_can_be_negated(token, template)
      if token_classifier.negated_long_option? && template.type != :boolean
        # TODO better error
        raise "#{token} is not a boolean option, you can only negate boolean option"
      end
    end
  end
end
