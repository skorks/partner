require 'partner/option'

module Partner
  module OptionFactory
    class BooleanOption
      attr_reader :template

      def initialize(template)
        @template = template
      end

      def build(token_iterator)
        ::Partner::Option.new(template, true, true)
      end
    end
  end
end
