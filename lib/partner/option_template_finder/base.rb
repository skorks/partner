module Partner
  module OptionTemplateFinder
    class Base
      attr_reader :option_template_library

      def initialize(option_template_library)
        @option_template_library = option_template_library
      end

      def find_template_for(token)
        # TODO more appropriate error
        raise 'Not implemented'
      end
    end
  end
end

