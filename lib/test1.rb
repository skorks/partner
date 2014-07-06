require 'partner'

# ruby -Ilib lib/test1.rb --foo

parser = Partner.configure do |config|
  config.option :foo
  config.option :foo2, default: 'hello'
  #config.option :foo, desc: 'Foo option'                   # type is string, default value is nil
  #config.option :bar, desc: 'Bar options', type: :boolean  # type is boolean, default value is false
  #config.option :baz, type: :int                           # type is int, default value is zero

  #config.command('hello world') do |command|
    #command.option :goo   # type is string, default value is nil
  #end
end
result = parser.parse
p result.options
p result.given_options
p result.default_options
#result.command
#result.arguments
