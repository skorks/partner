require 'partner/option'

module Partner
  module OptionFactory
    class NegatedBooleanOption
      attr_reader :template

      def initialize(template)
        @template = template
      end

      def build(token_iterator)
        ::Partner::Option.new(template, false, true)
      end
    end
  end
end
