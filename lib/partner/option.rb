require "forwardable"
require "partner/option_utils"
require "partner/option_types"

module Partner
  class Option
    extend Forwardable

    class << self
      def build(canonical_name:, type: nil, short: nil, long: nil, default: nil)
        type = OptionTypes.new.find_type(type) || OptionTypes::BooleanType.new
        long ||= OptionUtils.long_name_from_canonical_name(canonical_name)
        new(canonical_name, type, short, long, default)
      end
    end

    attr_reader :canonical_name, :type, :short, :long, :default

    def_delegators :type, :requires_argument?, :value_wrapper

    def initialize(canonical_name, type, short, long, default)
      @canonical_name = canonical_name
      @type = type
      @short = short
      @long = long
      @default = default
    end
  end
end
