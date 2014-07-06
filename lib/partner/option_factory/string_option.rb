require 'partner/option'

module Partner
  module OptionFactory
    class StringOption
      attr_reader :template

      def initialize(template)
        @template = template
      end

      def build(token_iterator)
        ::Partner::Option.new(template, token_iterator.next, true)
      end
    end
  end
end
