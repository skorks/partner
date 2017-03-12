require "partner/token_matcher/terminator"
require "partner/token_matcher/long_option"
require "partner/token_matcher/short_option"
require "partner/token_matcher/negated_long_option"
require "partner/token_matcher/short_option_with_value"
require "partner/token_matcher/combined_short_options"
require "partner/token_matcher/long_option_with_value_via_equals"
require "partner/token_matcher/short_option_with_value_via_equals"

require "partner/token_processor/terminator"
require "partner/token_processor/long_option"
require "partner/token_processor/short_option"
require "partner/token_processor/negated_long_option"
require "partner/token_processor/short_option_with_value"
require "partner/token_processor/combined_short_options"
require "partner/token_processor/long_option_with_value_via_equals"
require "partner/token_processor/short_option_with_value_via_equals"
require "partner/token_processor/argument"

module Partner
  class TokenClassifier
    MATCHER_TO_PROCESSOR = {
      TokenMatcher::Terminator => TokenProcessor::Terminator,
      TokenMatcher::LongOption => TokenProcessor::LongOption,
      TokenMatcher::ShortOption => TokenProcessor::ShortOption,
      TokenMatcher::NegatedLongOption => TokenProcessor::NegatedLongOption,
      TokenMatcher::ShortOptionWithValue => TokenProcessor::ShortOptionWithValue,
      TokenMatcher::CombinedShortOptions => TokenProcessor::CombinedShortOptions,
      TokenMatcher::LongOptionWithValueViaEquals => TokenProcessor::LongOptionWithValueViaEquals,
      TokenMatcher::ShortOptionWithValueViaEquals => TokenProcessor::ShortOptionWithValueViaEquals,
    }

    attr_reader :config

    def initialize(config:)
      @config = config
    end

    def find_processor_for(token)
      MATCHER_TO_PROCESSOR.each_pair do |matcher_class, processor_class|
        if matcher_class.new(config: config).matches?(token)
          return processor_class
        end
      end
      TokenProcessor::Argument
    end
  end
end
