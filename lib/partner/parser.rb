require 'partner/parser_result'
require 'partner/cli_token_iterator'

module Partner
  class Parser
    attr_reader :config

    def initialize(config)
      @config = config
    end

    def parse(argv = ARGV.dup)
      token_iterator = cli_token_iterator(argv)
      while token = token_iterator.next do
        if token.option? && config.option_template_library.contains?(token)
          # we need to build the concrete option now
        else
          # we don't know what to do with this token so put it in the leftovers list
        end
        # if token is an option
        puts token
      end
      ParserResult.new
    end

    private

    def cli_token_iterator(argv)
      CliTokenIterator.new(argv)
    end
  end
end
