module Partner
  module TokenMatcher
    class Base
      attr_reader :config, :result

      def initialize(config:, result:)
        @config = config
        @result = result
      end

      def matches?(token)
        raise "Not Implemented"
      end
    end
  end
end
