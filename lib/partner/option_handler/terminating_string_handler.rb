require "partner/option_handler/terminating_handler"

module Partner
  module OptionHandler
    class TerminatingStringHandler
      include TerminatingHandler

      def execute(data:, option_instance: nil)
        $stdout.puts data
      end
    end
  end
end
