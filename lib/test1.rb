require "shellwords"
require "partner"

config = Partner::Config.new
config.add_option(Partner::Option.build(canonical_name: :foo, type: "string"))
config.add_option(Partner::Option.build(canonical_name: :bob, type: "boolean", short: "-b"))
config.add_option(Partner::Option.build(canonical_name: :bar, type: "boolean"))
config.add_option(Partner::Option.build(canonical_name: :combi, type: "string", short: "-m"))
config.add_option(Partner::Option.build(canonical_name: :sss, type: "boolean", short: "-s"))
config.add_option(Partner::Option.build(canonical_name: :ppp, type: "boolean", short: "-p"))
config.add_option(Partner::Option.build(canonical_name: :qqq, type: "boolean", short: "-q"))
config.add_option(Partner::Option.build(canonical_name: :baz, type: "string"))
config.add_option(Partner::Option.build(canonical_name: :abc, type: "array[string]"))
config.add_option(Partner::Option.build(canonical_name: :def, type: "array[integer]"))
config.add_option(Partner::Option.build(canonical_name: :cleg, type: "string"))
config.add_option(Partner::Option.build(canonical_name: :c, type: "string"))
config.add_option(Partner::Option.build(canonical_name: :cred, type: "string"))
config.add_command("tooty fruity")
config.add_command("feet")

args = Shellwords.split(%Q(--foo 123 --cleg 'brown fox' -mcake -b --c x -spq --no-bar --baz=hello --cred="world" --abc r,s,t -- blah yadda))
result = Partner::Parser.new(config: config).parse(args)
p result
