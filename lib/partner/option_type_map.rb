require "partner/option_types/boolean_type"
require "partner/option_types/string_type"
require "partner/option_types/integer_type"
require "partner/option_types/float_type"
require "partner/option_types/array_type"

module Partner
  class OptionTypeMap
    BUILT_IN_TYPES = [
      OptionTypes::BooleanType.new,
      OptionTypes::StringType.new,
      OptionTypes::IntegerType.new,
      OptionTypes::FloatType.new,
      OptionTypes::ArrayType.new(item_type: OptionTypes::BooleanType.new),
      OptionTypes::ArrayType.new(item_type: OptionTypes::StringType.new),
      OptionTypes::ArrayType.new(item_type: OptionTypes::IntegerType.new),
      OptionTypes::ArrayType.new(item_type: OptionTypes::FloatType.new),
    ]

    class << self
      def build
        extra_option_types = (Partner.extra_option_types || [])
        option_types = (BUILT_IN_TYPES + extra_option_types).reduce({}) do |acc, type|
          (type.name_aliases + [type.name]).each do |key|
            acc[key] = type
          end
          acc
        end
        new(option_types)
      end
    end

    def find_by_name(name)
      @option_types[name]
    end

    private

    def initialize(option_types)
      @option_types = option_types
    end
  end
end
