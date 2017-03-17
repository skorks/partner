require "logger"

require "partner/token_iterator"
require "partner/parsing_context"
require "partner/token_classifier"
require "partner/error"
require "partner/config_syntax/basic"
require "partner/option_utils"

module Partner
  class Parser
    def initialize(
      config_syntax: Partner::ConfigSyntax::Basic,
      logger: nil,
      extra_option_types: [],
      extra_token_types: [],
      extra_pre_parsing_steps: [],
      extra_post_parsing_steps: []
    )
      @config_syntax = config_syntax

      Partner.logger = logger || Logger.new(File.open(File::NULL, "w"))
      Partner.extra_option_types = extra_option_types || []
      Partner.extra_token_types = extra_token_types || []
      Partner.extra_pre_parsing_steps = extra_pre_parsing_steps || []
      Partner.extra_post_parsing_steps = extra_post_parsing_steps || []
    end

    def parse(args = ARGV)
      Partner.logger.debug{ "#{self.class}.#{__method__}" }

      if block_given?
        syntax = @config_syntax.new
        yield(syntax)
        config = syntax.config

        parsing_context = ParsingContext.new(config: config, token_iterator: TokenIterator.new(args: args))

        PreParsingPhase.new(parsing_context: parsing_context).execute
        ParsingPhase.new(parsing_context: parsing_context).execute
        PostParsingPhase.new(parsing_context: parsing_context).execute

        parsing_context.result
      else
        raise "Not configuration provided for parser, please supply a configuration block to '#{__method__}'"
      end
    end

    private

    class BasePhase
      attr_reader :parsing_context

      def initialize(parsing_context:)
        @parsing_context = parsing_context
      end

      def execute
        raise "Not implemented"
      end
    end

    class PreParsingPhase < BasePhase
      def execute
        [
          UpdateResultWithDefaultOptionValues.new(parsing_context: parsing_context),
          GenerateShortNamesForOptions.new(parsing_context: parsing_context),
        ].each(&:execute)
      end

      class UpdateResultWithDefaultOptionValues
        attr_reader :parsing_context

        def initialize(parsing_context:)
          @parsing_context = parsing_context
        end

        def execute
          parsing_context.config.options_with_defaults.each do |option_instance|
            parsing_context.result.add_option_default(option_instance: option_instance)
          end
        end
      end

      class GenerateShortNamesForOptions
        attr_reader :parsing_context

        def initialize(parsing_context:)
          @parsing_context = parsing_context
        end

        def execute
          existing_short_names = parsing_context.config.existing_short_names
          parsing_context.config.options_requiring_short_names.each do |option_instance|
            possible_short_names = OptionUtils.generate_possible_short_names(option_instance.canonical_name)
            generated_short_name = OptionUtils.generate_short_name(possible_short_names, existing_short_names)
            option_instance.short = generated_short_name
            parsing_context.config.update_short_name_index(option_instance)
          end
        end
      end
    end

    class ParsingPhase < BasePhase
      def execute
        token_classifier = TokenClassifier.new(config: parsing_context.config, result: parsing_context.result)

        while parsing_context.token_iterator.has_next?
          token = parsing_context.token_iterator.next
          token_processor_class = nil
          if parsing_context.token_type_locked?
            token_processor_class = parsing_context.locked_token_processor_class
          else
            token_processor_class = token_classifier.find_processor_for(token)
          end
          token_processor = token_processor_class.new(parsing_context: parsing_context)
          token_processor.process(token)
        end
      end
    end

    class PostParsingPhase < BasePhase
      def execute
        [
          EnsureCommandValid.new(parsing_context: parsing_context),
          EnsureRequiredOptionsGiven.new(parsing_context: parsing_context),
        ].each(&:execute)
        # EnsureDependenciesSatisfied
        # EnsureNoConflicts
      end

      class EnsureCommandValid
        attr_reader :parsing_context

        def initialize(parsing_context:)
          @parsing_context = parsing_context
        end

        def execute
          unless parsing_context.config.valid_command?(parsing_context.result.command)
            raise InvalidCommandError.new(parsing_context.result.command)
          end
        end
      end

      class EnsureRequiredOptionsGiven
        attr_reader :parsing_context

        def initialize(parsing_context:)
          @parsing_context = parsing_context
        end

        def execute
          result = parsing_context.config.required_options.reduce([]) do |acc, option_instance|
            unless parsing_context.result.option_has_value?(option_instance: option_instance)
              acc << option_instance.canonical_name
            end
            acc
          end
          if result.length > 0
            raise RequiredOptionsMissingError.new(result)
          end
        end
      end
    end
  end
end
