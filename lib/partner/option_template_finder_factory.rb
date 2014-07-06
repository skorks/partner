require 'partner/option_template_finder/long_option'
require 'partner/option_template_finder/short_option'
require 'partner/option_template_finder/negated_long_option'

module Partner
  class OptionTemplateFinderFactory
    attr_reader :option_template_library

    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def build(token_classifier)
      if token_classifier.short_option?
        OptionTemplateFinder::ShortOption.new(option_template_library)
      elsif token_classifier.long_option?
        OptionTemplateFinder::LongOption.new(option_template_library)
      elsif token_classifier.negated_long_option?
        OptionTemplateFinder::NegatedLongOption.new(option_template_library)
      end
    end
  end
end
