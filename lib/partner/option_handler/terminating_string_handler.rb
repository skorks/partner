module Partner
  module OptionHandler
    class TerminatingStringHandler
      def execute(data:, option_instance: nil)
        $stdout.puts data
      end

      def terminating?
        true
      end
    end
  end
end
