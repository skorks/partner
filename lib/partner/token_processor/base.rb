module Partner
  module TokenProcessor
    class Base
      attr_reader :parsing_context

      def initialize(parsing_context:)
        @parsing_context = parsing_context
      end

      def process(token)
        raise "Not implemented"
      end
    end
  end
end
