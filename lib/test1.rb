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

class TokenClassifier
  # attr_reader :token_iterator
  #
  # def initialize(token_iterator = nil)
  #   @token_iterator = token_iterator
  # end

  TOKEN_TYPES = {
    terminator: :terminator?,
    long_option: :long_option?,
    short_option: :short_option?,
    option_value: :option_value?,
  }

  def classify(token)
    TOKEN_TYPES.each do |token_type, predicate_method|
      return token_type if send(predicate_method)
    end
    return :unknown
  end

  def terminator?(token)
    token == "--"
  end

  def long_option?(token)
    token.start_with?("--") && !token.start_with?("--no-") && !terminator?
  end

  def short_option?(token)
    token.start_with?("-") && token.length == 2 && !terminator?
  end

  def option_value?(token)
    token_object = tokenization_context.previous_token
    token_object.option? && token_object.takes_value? && !option?(token)
    # previous token is an option which can take a value
    # tokenization_context.
  end

  # def option?
  #   if short_option? ||
  #     long_option? ||
  #     negated_long_option? ||
  #     combined_short_options?
  #     true
  #   else
  #     false
  #   end
  # end
  #
  # def combined_short_options?
  #   token.start_with?('-') &&
  #     !token.start_with?('--') &&
  #     token.length > 2
  # end
  #
  # def short_option?
  #   token.start_with?('-') &&
  #     token.length == 2 &&
  #     !token.start_with?('--')
  # end
  #
  # def long_option?
  #   token.start_with?('--') && !token.start_with?('--no-') && !terminator?
  # end
  #
  # def negated_long_option?
  #   token.start_with?('--no-')
  # end
  #
  # def terminator?
  #   token == '--'
  # end
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
args1 = Shellwords.split(%Q(--foo 123 --cleg 'brown fox' -b --c x -spq --no-bar --baz=hello --cred="world"))


def terminator?(token)
  token == "--"
end

def long_option?(token)
  token.start_with?("--") && !token.start_with?("--no-") && !terminator?(token)
end

def short_option?(token)
  token.start_with?("-") && token.length == 2 && !terminator?(token)
end

def combined_short_options?(token)
  token.start_with?('-') && !token.start_with?('--') && token.length > 2
end

def negated_long_option?(token)
  token.start_with?('--no-')
end

def normalize_args(args)
  normalized_args = []
  args.each do |arg|
    if combined_short_options?(arg)
      short_options = arg[1, arg.length].split("").map{|v| "-#{v}"}
      normalized_args += short_options
    else
      normalized_args += arg.split("=")
    end
  end
  normalized_args
end


normalized_args = normalize_args(args1)

class OptionUtils
  class << self
    def long_name_from_canonical_name(canonical_name)
      partial_long = canonical_name.to_s.gsub("_", "-")
      "--#{partial_long}"
    end

    def negated_long_name_from_long_name(long_name)
      long_name.sub("--", "--no-")
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

  def flag?
    type == :boolean
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

config = Config.new
config.add_option(Option.build(canonical_name: :foo, type: :string))
config.add_option(Option.build(canonical_name: :bob, type: :boolean, short: "-b"))

p normalized_args

given_options = {}
arguments = []
next_token_position = 0
(0...normalized_args.length).each do |index|
  next_token_position += 1
  token = normalized_args[index]
  if terminator?(token)
    break
  elsif long_option?(token)
    option = config.find_option_by_long(token)
    if option
      if option.flag?
        given_options[option.canonical_name] = true
      else
        given_options[option.canonical_name] = normalized_args[index + 1]
        # skip the next token
      end
      p option
    end
  elsif negated_long_option?(token)
  elsif short_option?(token)
    option = config.find_option_by_short(token)
    if option
      if option.flag?
        given_options[option.canonical_name] = true
      else
        given_options[option.canonical_name] = normalized_args[index + 1]
        # skip the next token
      end
      p option
    end
  end
end
start_position = next_token_position
(start_position...normalized_args.length).each do |index|
  next_token_position += 1
  arguments << normalized_args[index]
end
p given_options
p arguments
