module Partner
  class NaiveCommandLine
    attr_reader :script_name, :cli_tokens

    def initialize(cli_tokens = ARGV.dup, options = {})
      @cli_tokens = cli_tokens
      @script_name = $0.dup.freeze
      @leftovers = nil
      @options = nil
    end

    def hello
      p cli_tokens
    end

    #-x
    #--xxx
    #--no-xxx
    #-xyz
    #-x foo
    #--xxx foo
    #-x=foo
    #--xxx=foo
    #-x foo -x bar
    #--xxx foo --xxx bar
    #-x=foo -x=bar
    #--xxx=foo --xxx=bar
    #-x [1, 2, 3]
    #-x=[1, 2, 3]
    #--xxx [1, 2, 3]
    #--xxx=[1, 2, 3]
    #-x {a=1, b=2}
    #-x={a=1, b=2}
    #--xxx {a=1, b=2}
    #--xxx={a=1, b=2}
    #-- by itself ends option processing
    #--xxx='hello world'
    #--xxx="hello world"
    #--xxx "hello world"
    #--xxx 'hello world'
    #-x 'hello world'
    def options
      @options ||= cli_arguments.reduce({}) do |acc, token|
      end
    end

    def leftovers
    end
  end
end

if __FILE__ == $0
  Partner::NaiveCommandLine.new.hello
  Partner::NaiveCommandLine.new(["blah"]).hello
end

#require 'partner'
#Partner::NaiveCommandLine.new
