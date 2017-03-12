require "partner/option_utils"

module Partner
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
end
