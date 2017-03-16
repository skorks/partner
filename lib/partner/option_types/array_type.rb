require "partner/option_types/base"
require "partner/option_types/string_type"

module Partner
  module OptionTypes
    class ArrayType < Base
      def initialize(item_type: StringType.new)
        @item_type = item_type
      end

      def name
        "#{base_name}[#{@item_type.name}]"
      end

      def name_aliases
        @item_type.name_aliases.map do |name_alias|
          "#{base_name}[#{name_alias}]"
        end
      end

      def cast(value, delimiter = ",")
        value.split(delimiter).map do |item|
          @item_type.cast(item)
        end
      end

      def default_value
        []
      end

      private

      def base_name
        "array"
      end
    end
  end
end
