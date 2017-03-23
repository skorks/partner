require "partner/config"

module Partner
  module ConfigSyntax
    class Basic

      def initialize
        @config = Partner::Config.new
      end

      def config
        @config
      end

      def option(options = {})
        @config.add_option(Partner::Option.build(options))
      end

      def version_option(options = {})
        options[:canonical_name] ||= :version
        options[:type] ||= "boolean"
        options[:long] ||= "--version"
        options[:short] ||= "-v"
        options[:default] ||= options[:value]

        @config.add_option(Partner::Option.build(options))
      end

      def command(command_string)
        @config.add_command(command_string)
      end
    end
  end
end
