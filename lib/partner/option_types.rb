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
      nil
    end

    class BaseType
      def to_s
        raise "Not implemented"
      end

      def requires_argument?
        true
      end

      def value_wrapper
        self::class::Value.new
      end
    end

    class BooleanType < BaseType
      def to_s
        "boolean"
      end

      def requires_argument?
        false
      end

      class Value
        attr_reader :raw

        def initialize
          @raw = nil
        end

        def update(value)
          @raw = !!value
        end
      end
    end

    class StringType < BaseType
      def to_s
        "string"
      end

      class Value
        attr_reader :raw

        def initialize
          @raw = nil
        end

        def update(value)
          @raw = value.to_s
        end
      end
    end

    class IntegerType < BaseType
      def to_s
        "integer"
      end

      class Value
        attr_reader :raw

        def initialize
          @raw = nil
        end

        def update(value)
          @raw = value.to_i
        end
      end
    end

    class FloatType < BaseType
      def to_s
        "float"
      end

      class Value
        attr_reader :raw

        def initialize
          @raw = nil
        end

        def update(value)
          @raw = BigDecimal.new(value)
        end
      end
    end

    class ArrayType < BaseType
      def initialize(item_type: StringType)
        @item_type = item_type
      end

      def to_s
        "array[#{@item_type.new.to_s}]"
      end

      def value_wrapper
        self::class::Value.new(item_type: @item_type)
      end

      class Value
        attr_reader :raw

        def initialize(item_type:)
          @raw = []
          @item_type = item_type
        end

        # TODO maybe make it so delimiter can be configurable
        def update(value)
          value.split(",").each do |item|
            wrapped_value = @item_type::Value.new
            wrapped_value.update(item)
            @raw << wrapped_value.raw
          end
        end
      end
    end
  end
end
