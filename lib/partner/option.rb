require "forwardable"
require "partner/option_utils"
require "partner/option_type_map"
require "partner/option_types/boolean_type"

module Partner
  class Option
    extend Forwardable

    class << self
      def build(
        canonical_name:,
        type: nil,
        short: nil,
        long: nil,
        default: nil,
        required: false,
        depends_on: [],
        conflicts_with: [],
        handler: nil,
        validator: nil,
        aliases: []
      )
        canonical_name = canonical_name.to_s
        type = OptionTypeMap.build.find_by_name(type) || OptionTypes::BooleanType.new
        long = long.to_s || OptionUtils.long_name_from_canonical_name(canonical_name)
        new(
          canonical_name: canonical_name,
          type: type,
          short: short,
          long: long,
          default: default,
          required: required,
          depends_on: depends_on,
          conflicts_with: conflicts_with,
          handler: handler,
          validator: validator,
          aliases: aliases,
        )
      end
    end

    attr_reader :canonical_name, :type, :short,
      :long, :default, :required,
      :depends_on, :conflicts_with, :handler,
      :validator, :aliases

    attr_writer :short

    def_delegators :type, :requires_argument?

    def initialize(
        canonical_name:,
        type:,
        short:,
        long:,
        default:,
        required:,
        depends_on:,
        conflicts_with:,
        handler:,
        validator:,
        aliases:
    )
      @canonical_name = canonical_name
      @type = type
      @short = short
      @long = long
      @default = default
      @required = required
      @depends_on = depends_on
      @conflicts_with = conflicts_with
      @handler = handler
      @validator = validator
      @aliases = aliases
    end

    def has_short_name?
      short && short != :none
    end

    def needs_short_name?
      !short && short != :none
    end

    def all_names
      list = []
      list << canonical_name.to_s
      list << long.to_s
      list << short.to_s if needs_short_name?
      list
    end

    def all_aliases
      aliases.map(&:to_s).uniq
    end
  end
end
