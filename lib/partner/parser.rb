require "partner/token_iterator"
require "partner/parsing_context"
require "partner/token_classifier"
require "partner/error"
require "logger"

module Partner
  class Parser
    def initialize(config_syntax: NullSyntax, logger: nil)
      @config_syntax = config_syntax
      @logger = logger
    end

    def parse(args = ARGV)
      Partner.logger = Logger.new($stdout).tap do |logger|
        logger.level = Logger::DEBUG
      end
      Partner.logger.info("HELLO")
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

    class NullSyntax
      attr_accessor :config

      def initialize
        @config = nil
      end
    end

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
        ].each(&:execute)
        # UpdateResultWithDefaultOptionValues
        # DeriveOptionTypesFromDefaultValues
        # EnsureNoCanonicalOptionNameConflicts
        # EnsureNoLongOptionNameConflicts
        # EnsureNoShortOptionNameConflicts
        # GenerateShortNamesForOptions
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
        # EnsureRequiredOptionsGiven
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
            raise Error::InvalidCommandError.new(parsing_context.result.command)
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
            raise Error::RequiredOptionsMissingError.new(result)
          end
        end
      end
    end
  end
end
