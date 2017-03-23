module Partner
  module OptionHandler
    class Version
      def initialize(value:, option_instance: nil)
        @value = value
        @option_instance = option_instance
      end

      def execute
        $stdout.puts @value
      end

      def terminating?
        true
      end
    end
  end
end
