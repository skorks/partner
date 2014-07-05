require 'partner/parser_result'
require 'partner/option_parser'
require 'partner/command_parser'


module Partner
  class Parser
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def parse(argv = ARGV.dup)
      ::Partner.logger.debug "#{self.class.name} parse start"

      option_parser_result = OptionParser.new(config).parse(argv)
      command_parser_result = CommandParser.new(config).parse(option_parser_result.leftovers)

      ::Partner.logger.debug "#{self.class.name} parse end"

      ParserResult.new(option_parser_result.options, command_parser_result.command, command_parser_result.leftovers)
    rescue => e
      #TODO introduce an error reporter here instead of a puts
      $stderr.puts "An error has occured: #{e.message}, #{e.backtrace.join("\n")}"
    end
  end
end
