require 'partner/parser_result'
require 'partner/option_parser'
require 'partner/command_parser'


module Partner
  class Parser
    attr_reader :option_template_library

    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def parse(argv = ARGV.dup)
      ::Partner.logger.debug "#{self.class.name} parse start"

      option_parser_result = OptionParser.new(option_template_library).parse(argv)
      #command_parser_result = CommandParser.new(config).parse(option_parser_result.leftovers)

      ::Partner.logger.debug "#{self.class.name} parse end"

      #ParserResult.new(option_parser_result.options, command_parser_result.command, command_parser_result.leftovers)
      ParserResult.new(option_parser_result.options, nil, nil)
    rescue => e
      #TODO introduce an error reporter here instead of a puts
      $stderr.puts "#{e.message}\n#{e.backtrace.join("\n")}"
      nil
    end
  end
end
