require "partner/option_types/base"

module Partner
  module OptionTypes
    class IntegerType < Base
      def name_aliases
        ["i", "int"]
      end

      def cast(value)
        # TODO change this to Integer(value) with appropriate error handling
        value.to_i
      end
    end
  end
end
