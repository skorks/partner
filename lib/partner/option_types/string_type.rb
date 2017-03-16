require "partner/option_types/base"

module Partner
  module OptionTypes
    class StringType < Base
      def name_aliases
        ["s", "str"]
      end

      def cast(value)
        value.to_s
      end
    end
  end
end
