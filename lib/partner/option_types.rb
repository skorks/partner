module Partner
  class OptionTypes
    def find_type(option_type_string)
      [
        BooleanType.new,
        StringType.new,
        IntegerType.new,
        FloatType.new,
        ArrayType.new(item_type: BooleanType),
        ArrayType.new(item_type: StringType),
        ArrayType.new(item_type: IntegerType),
        ArrayType.new(item_type: FloatType),
      ].each do |type_instance|
        if type_instance.to_s == option_type_string
          return type_instance
        end
      end
    end

    class BooleanType
      def to_s
        "boolean"
      end

      def requires_argument?
        false
      end

      def cast_value(value)
        !!value
      end
    end

    class StringType
      def to_s
        "string"
      end

      def requires_argument?
        true
      end

      def cast_value(value)
        value.to_s
      end
    end

    class IntegerType
      def to_s
        "integer"
      end

      def requires_argument?
        true
      end

      def cast_value(value)
        # TODO perhaps this should blow up if can't cast
        value.to_i
      end
    end

    class FloatType
      def to_s
        "float"
      end

      def requires_argument?
        true
      end

      def cast_value(value)
        # TODO perhaps this should blow up if can't cast
        BigDecimal.new(value)
      end
    end

    class ArrayType
      def initialize(item_type: StringType)
        @item_type = item_type
      end

      def to_s
        "array[#{@item_type.new.to_s}]"
      end

      def requires_argument?
        true
      end

      def cast_value(value)
        [value].flatten.map do |item|
          @item_type.new.cast_value(item)
        end
      end
    end
  end
end
