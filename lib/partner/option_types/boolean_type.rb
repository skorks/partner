require "partner/option_types/base"

module Partner
  module OptionTypes
    class BooleanType < Base
      def name_aliases
        ["b", "bool"]
      end

      def requires_argument?
        false
      end

      def cast(value)
        !!value
      end

      def default_value
        false
      end
    end
  end
end
