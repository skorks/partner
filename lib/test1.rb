# require 'partner'
#
# # ruby -Ilib lib/test1.rb --foo
#
# parser = Partner.configure do |config|
#   config.option :foo, short: 'f', long: '--foo'
#   config.option :foo2, default: 'hello', short: '-2'
#   config.option :myflag, type: :boolean, short: '-m'
#   config.option :nyflag, type: :boolean, default: true, short: '-n'
#   config.option :ryflag, type: :boolean, short: '-r'
#   config.option :many, short: 'a', multi: true
#   #config.option :myflag3, type: :boolean, default: "BALH"
#   #config.option :foo, desc: 'Foo option'                   # type is string, default value is nil
#   #config.option :bar, desc: 'Bar options', type: :boolean  # type is boolean, default value is false
#   #config.option :baz, type: :int                           # type is int, default value is zero
#
#   #config.command('hello world') do |command|
#     #command.option :goo   # type is string, default value is nil
#   #end
# end
# result = parser.parse
# p result.options
# p result.given_options
# p result.default_options
#result.command
#result.arguments

# key, short dec, long desc, type, default value, required,
# Partner.template({
#   foo: ['f', 'myfoo', :bool, false, false, "Foo happy foo"],
#   bar: ['b', nil, :string, nil, true, "Bar is good too"]
# })

# p $PROGRAM_NAME
# p ARGV

class TokenIterator
  attr_reader :tokens, :current_index

  def initialize(tokens: [])
    @tokens = tokens || []
    @current_index = 0
  end

  def next
    if current_index == tokens.size
      nil
    else
      tokens[current_index]
    end
  end

  def has_next?
    current_index < tokens.size
  end
end


#concepts
#----------------
# option templates
# option template
# tokenization context
# actual token type
# expected token type
# normalized token

require "shellwords"

# tokenization_context = TokenizationContext.new
# token_iterator = TokenIterator.new(tokens: args1)
# token_classifier = TokenClassifier.new(tokenization_context: tokenization_context)

# while token_iterator.has_next? do
#   token = token_iterator.next.first
#   token_type = token_classifier.classify(token)
#   normalized_token = token_normalizer.normalize(token, token_type)
#   token_object = Token.new(token, token_type, normalized_token)
#   validation_result = token_validator.validate(token_object, tokenization_context)
#   raise validation_result.error if validation_result.failure?
#   tokenization_context.add(token_object)
# end

# token_types = {
#   terminator: "--",
#   long_option: "--long",
#   short_option: "-s",
#   combined_short_options: "-spq",
#   negated_long_option: "--no-long",
#   option_value: {
#     string: "abc123",
#     comma_separated_string:"a,b,c",
#   },
#   long_option_with_value: "--long=hello",
#   long_option_with_value_quoted: "--long='hello'",
#   short_option_with_value: "-s=hello",
#   short_option_with_value_quoted: "-s='hello'",
#   argument_string: nil,
#   command_string: nil,
# }

# long_options - longer than 2 chars, starts with --, does not start with --no-,



class OptionUtils
  class << self
    def long_name_from_canonical_name(canonical_name)
      partial_long = canonical_name.to_s.gsub("_", "-")
      "--#{partial_long}"
    end

    def negated_long_name_from_long_name(long_name)
      long_name.sub("--", "--no-")
    end

    def long_name_from_negated_long_name(negated_long_name)
      negated_long_name.sub("--no-", "--")
    end
  end
end

class Option
  class << self
    def build(canonical_name:, type: nil, short: nil, long: nil)
      type ||= :boolean
      long ||= OptionUtils.long_name_from_canonical_name(canonical_name)
      new(canonical_name, type, short, long)
    end
  end

  attr_reader :canonical_name, :type, :short, :long

  def initialize(canonical_name, type, short, long)
    @canonical_name = canonical_name
    @type = type
    @short = short
    @long = long
  end

  def requires_argument?
    type != :boolean
  end
end

class Config
  def initialize
    @options_by_canonical_name = {}
    @options_by_short = {}
    @options_by_long = {}
  end

  def add_option(option)
    @options_by_canonical_name[option.canonical_name] = option
    @options_by_long[option.long] = option
    @options_by_short[option.short] = option if option.short
  end

  def find_option_by_long(token)
    @options_by_long[token]
  end

  def find_option_by_short(token)
    @options_by_short[token]
  end
end

class TokenIterator
  attr_reader :args

  def initialize(args:)
    @args = args
    @next_token_position = 0
  end

  def next
    token = args[@next_token_position]
    @next_token_position += 1
    token
  end

  def has_next?
    @next_token_position < args.length
  end
end

class Result
  def initialize
    @given_options = {}
    @arguments = []
  end

  def add_option(canonical_name:, value:)
    @given_options[canonical_name] = value
  end

  def add_argument(value:)
    @arguments << value
  end
end

class TokenProcessor
  attr_reader :parsing_context

  def initialize(parsing_context:)
    @parsing_context = parsing_context
  end

  def process(token)
    false
  end
end

class ArgumentTokenProcessor < TokenProcessor
  def process(token)
    parsing_context.result.add_argument(value: token)
    true
  end
end

class TerminatorTokenProcessor < TokenProcessor
  def process(token)
    if can_process?(token)
      parsing_context.lock_token_type(token_processor_class: ArgumentTokenProcessor)
      true
    else
      false
    end
  end

  def can_process?(token)
    token == "--"
  end
end

class LongOptionTokenProcessor < TokenProcessor
  def process(token)
    if can_process?(token)
      option_instance = parsing_context.config.find_option_by_long(token)

      if option_instance
        if option_instance.requires_argument?
          if parsing_context.token_iterator.has_next?
            parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: parsing_context.token_iterator.next)
          else
            # this means input is invalid and should be handled appropriately e.g. raise error
          end
        else
          parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: true)
        end
        true
      else
        # this means input is invalid and should be handled appropriately e.g. raise error
      end
    else
      false
    end
  end

  def can_process?(token)
    token.start_with?("--") &&
    !token.start_with?("--no-") &&
    !TerminatorTokenProcessor.new(parsing_context: parsing_context).can_process?(token)
  end
end

class ShortOptionTokenProcessor < TokenProcessor
  def process(token)
    if can_process?(token)
      option_instance = parsing_context.config.find_option_by_short(token)

      if option_instance
        if option_instance.requires_argument?
          if parsing_context.token_iterator.has_next?
            parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: parsing_context.token_iterator.next)
          else
            # this means input is invalid and should be handled appropriately e.g. raise error
          end
        else
          parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: true)
        end
        true
      else
        # this means input is invalid and should be handled appropriately e.g. raise error
      end
    else
      false
    end
  end

  def can_process?(token)
    token.start_with?("-") &&
    token.length == 2 &&
    !TerminatorTokenProcessor.new(parsing_context: parsing_context).can_process?(token)
  end
end

class NegatedLongOptionTokenProcessor < TokenProcessor
  def process(token)
    if can_process?(token)
      option_instance = parsing_context.config.find_option_by_long(OptionUtils.long_name_from_negated_long_name(token))

      if option_instance
        parsing_context.result.add_option(canonical_name: option_instance.canonical_name, value: false)
        true
      else
        # this means input is invalid and should be handled appropriately e.g. raise error
      end
    else
      false
    end
  end

  def can_process?(token)
    token.start_with?('--no-')
  end
end

class ParsingContext
  attr_reader :config, :result, :token_iterator
  attr_reader :locked_token_processor_class

  def initialize(config:, result:, token_iterator:)
    @config = config
    @result = result
    @token_iterator = token_iterator
    @locked_token_processor_class = nil
  end

  def lock_token_type(token_processor_class:)
    @locked_token_processor_class = token_processor_class
  end

  def token_type_locked?
    locked_token_processor_class != nil
  end
end

class Parser
  attr_reader :config

  def initialize(config:)
    @config = config
  end

  def parse(args)
    p args
    result = Result.new
    token_iterator = TokenIterator.new(args: args)
    parsing_context = ParsingContext.new(config: config, result: result, token_iterator: token_iterator)

    while token_iterator.has_next?
      token = token_iterator.next
      [
        TerminatorTokenProcessor,
        LongOptionTokenProcessor,
        ShortOptionTokenProcessor,
        NegatedLongOptionTokenProcessor,

        # ShortOptionWithValueTokenProcessor,
        # CombinedShortOptionsTokenProcessor,
        # LongOptionWithValueViaEqualsTokenProcessor,
        # ShortOptionWithValueViaEqualsTokenProcessor,
        # CommandWordTokenProcessor,
        # ArgumentTokenProcessor # must be last to slurp up any tokens which we couldn't classify before
      ].each do |token_processor_class|
        if parsing_context.token_type_locked?
          token_processor = parsing_context.locked_token_processor_class.new(parsing_context: parsing_context)
        else
          token_processor = token_processor_class.new(parsing_context: parsing_context)
        end
        break if token_processor.process(token)
      end
    end

    # while token_iterator.has_next?
    #   token = token_iterator.next
    #   if terminator?(token)
    #     break
    #   elsif long_option?(token)
    #     option = config.find_option_by_long(token)
    #     result.add_option(option_instance: option, token_iterator: token_iterator)
    #   elsif negated_long_option?(token)
    #     option = config.find_option_by_long(OptionUtils.long_name_from_negated_long_name(token))
    #     result.add_negated_boolean_option(option_instance: option)
    #   elsif short_option?(token)
    #     option = config.find_option_by_short(token)
    #     result.add_option(option_instance: option, token_iterator: token_iterator)
    #   end
    # end
    # while token_iterator.has_next?
    #   result.add_argument(value: token_iterator.next)
    # end

    result
  end

  private

  # def normalize_args(args)
  #   normalized_args = []
  #   args.each do |arg|
  #     if combined_short_options?(arg)
  #       short_options = arg[1, arg.length].split("").map{|v| "-#{v}"}
  #       normalized_args += short_options
  #     else
  #       normalized_args += arg.split("=")
  #     end
  #   end
  #   normalized_args
  # end
end

# class TokenClassifier
#   TOKEN_TYPES = {
#     terminator: :terminator?,
#     long_option: :long_option?,
#     short_option: :short_option?,
#     negated_long_option: :negated_long_option?,
#   }
#
#   def classify(token)
#     TOKEN_TYPES.each do |token_type, predicate_method|
#       return token_type if send(predicate_method, token)
#     end
#     return :unknown
#   end
#
#   def terminator?(token)
#     token == "--"
#   end
#
#   def long_option?(token)
#     token.start_with?("--") && !token.start_with?("--no-") && !terminator?(token)
#   end
#
#   def short_option?(token)
#     token.start_with?("-") && token.length == 2 && !terminator?(token)
#   end
#
#   def combined_short_options?(token)
#     token.start_with?('-') && !token.start_with?('--') && token.length > 2
#   end
#
#   def negated_long_option?(token)
#     token.start_with?('--no-')
#   end
# end


config = Config.new
config.add_option(Option.build(canonical_name: :foo, type: :string))
config.add_option(Option.build(canonical_name: :bob, type: :boolean, short: "-b"))
config.add_option(Option.build(canonical_name: :bar, type: :boolean))

args = Shellwords.split(%Q(--foo 123 --cleg 'brown fox' -b --c x -spq --no-bar --baz=hello --cred="world" -- blah yadda))
result = Parser.new(config: config).parse(args)
p result

# handle combined short options vs short option with value without space
