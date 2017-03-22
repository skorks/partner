require "partner/token_matcher/terminator"
require "partner/token_matcher/option"
require "partner/token_matcher/option_with_value_via_equals"
require "partner/token_matcher/negated_long_option"
require "partner/token_matcher/short_option_with_value"
require "partner/token_matcher/combined_short_options"
require "partner/token_matcher/command_word"

require "partner/token_processor/terminator"
require "partner/token_processor/option"
require "partner/token_processor/option_with_value_via_equals"
require "partner/token_processor/negated_long_option"
require "partner/token_processor/short_option_with_value"
require "partner/token_processor/combined_short_options"
require "partner/token_processor/argument"
require "partner/token_processor/command_word"

module Partner
  class TokenClassifier
    MATCHER_TO_PROCESSOR = {
      TokenMatcher::Terminator => TokenProcessor::Terminator,
      TokenMatcher::Option => TokenProcessor::Option,
      TokenMatcher::OptionWithValueViaEquals => TokenProcessor::OptionWithValueViaEquals,
      TokenMatcher::NegatedLongOption => TokenProcessor::NegatedLongOption,
      TokenMatcher::ShortOptionWithValue => TokenProcessor::ShortOptionWithValue,
      TokenMatcher::CombinedShortOptions => TokenProcessor::CombinedShortOptions,
      TokenMatcher::CommandWord => TokenProcessor::CommandWord,
    }

    attr_reader :config, :result

    def initialize(config:, result:)
      @config = config
      @result = result
    end

    def find_processor_for(token)
      MATCHER_TO_PROCESSOR.each_pair do |matcher_class, processor_class|
        if matcher_class.new(config: config, result: result).matches?(token.strip)
          return processor_class
        end
      end
      TokenProcessor::Argument
    end
  end
end
