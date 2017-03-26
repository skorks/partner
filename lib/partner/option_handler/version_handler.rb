require "partner/option_handler/terminating_handler"

module Partner
  module OptionHandler
    class VersionHandler
      include TerminatingHandler

      def initialize(version_string)
        @version_string = version_string
      end

      def execute(data:, option_instance: nil)
        $stdout.puts @version_string
      end
    end
  end
end
