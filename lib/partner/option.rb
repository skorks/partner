require "forwardable"
require "partner/option_utils"
require "partner/option_type_map"
require "partner/option_types/boolean_type"
require "partner/option_handler/version"

module Partner
  class Option
    extend Forwardable

    class << self
      def default_attributes
        {
          canonical_name: nil,
          type: nil,
          short: nil,
          long: nil,
          default: nil,
          required: false,
          depends_on: [],
          conflicts_with: [],
          handler: nil,
          validator: nil,
          aliases: [],
        }
      end

      def build_version(value, attributes = {})
        default_version_option_attributes = {
          canonical_name: :version,
          type: "boolean",
          short: "-v",
          long: "--version",
          handler: Partner::OptionHandler::Version.new(value: value)
        }
        build(default_attributes.merge(default_version_option_attributes).merge(attributes))
      end

      def build(attributes = {})
        #TODO raise if there is no canonical_name
        option_attributes = default_attributes.merge(attributes)
        canonical_name = option_attributes[:canonical_name]
        type = option_attributes[:type]
        option_attributes[:type] = OptionTypeMap.build.find_by_name(type.to_s) || OptionTypes::BooleanType.new
        option_attributes[:long] ||= OptionUtils.long_name_from_canonical_name(canonical_name)
        new(option_attributes)
      end
    end

    attr_reader :canonical_name, :type, :short,
      :long, :default, :required,
      :depends_on, :conflicts_with, :handler,
      :validator, :aliases

    attr_writer :short

    def_delegators :type, :requires_argument?

    def initialize(attributes = {})
      @canonical_name = attributes[:canonical_name]
      @type = attributes[:type]
      @short = attributes[:short]
      @long = attributes[:long]
      @default = attributes[:default]
      @required = attributes[:required]
      @depends_on = attributes[:depends_on]
      @conflicts_with = attributes[:conflicts_with]
      @handler = attributes[:handler]
      @validator = attributes[:validator]
      @aliases = attributes[:aliases]
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
      list << short.to_s if has_short_name?
      list
    end

    def all_aliases
      aliases.map(&:to_s).uniq
    end
  end
end
