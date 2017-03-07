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

  def next(n=1)
    if current_index == tokens.size
      nil
    else
      tokens[current_index, n].tap do
        @current_index += n
      end
    end
  end

  def has_next?
    current_index < tokens.size
  end

  def look_ahead
    n=1
    tokens[current_index, n]
  end

  def look_behind
    n=1
    tokens[(current_index - n - 1)...current_index - 1]
  end

  # return all values until we see one that satisfies the block
  def next_until(&block)
  end

  # def remaining
  #   tokens[@current_index..tokens.size]
  # end
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

token_types = [
  :long_option,
  :option_value,
  :noop,
]

template = {
  options: {
    # foo: { short: "f", long: "foo", type: :string, default: "", required: true, desc: "Foo value" }
    foo: { type: :string },
    bar: { type: :boolean }
  },
}
args1 = Shellwords.split("--foo")

tokenization_context = TokenizationContext.new
token_iterator = TokenIterator.new(tokens: args1)
token_classifier = TokenClassifier.new(tokenization_context: tokenization_context)

while token_iterator.has_next? do
  token = token_iterator.next.first
  token_type = token_classifier.classify(token)
  normalized_token = token_normalizer.normalize(token, token_type)
  token_object = Token.new(token, token_type, normalized_token)
  validation_result = token_validator.validate(token_object, tokenization_context)
  raise validation_result.error if validation_result.failure?
  tokenization_context.add(token_object)
end
