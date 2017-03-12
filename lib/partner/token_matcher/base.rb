module Partner
  module TokenMatcher
    class Base
      attr_reader :config

      def initialize(config:)
        @config = config
      end

      def matches?(token)
        raise "Not Implemented"
      end
    end
  end
end
