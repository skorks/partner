require "partner/token_iterator"
require "partner/parsing_context"
require "partner/token_classifier"

module Partner
  class Parser
    attr_reader :config

    def initialize(config:)
      @config = config
    end

    def parse(args)
      p args
      parsing_context = ParsingContext.new(config: config, token_iterator: TokenIterator.new(args: args))

      PreParsingPhase.new(parsing_context: parsing_context).execute
      ParsingPhase.new(parsing_context: parsing_context).execute
      PostParsingPhase.new(parsing_context: parsing_context).execute

      parsing_context.result
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
      end
    end

    class ParsingPhase < BasePhase
      def execute
        token_classifier = TokenClassifier.new(config: parsing_context.config)

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
      end
    end
  end
end
