require "partner/option_types/base"

module Partner
  module OptionTypes
    class FloatType < Base
      def name_aliases
        ["f", "flt"]
      end

      def cast(value)
        # TODO work out if it's ok for it to be using BigDecimal
        BigDecimal.new(value)
      end
    end
  end
end
