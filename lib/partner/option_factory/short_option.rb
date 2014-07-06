require 'partner/option'

module Partner
  module OptionFactory
    class ShortOption
      attr_reader :option_template_library, :token, :token_iterator

      def initialize(option_template_library, token, token_iterator)
        @option_template_library = option_template_library
        @token = token
        @token_iterator = token_iterator
      end

      def build
        template = option_template_library.find_by_short_name(token)

        ::Partner.logger.debug "#{self.class.name} found template for token #{token}, #{template}"

        if template
          ::Partner::Option.new(template).add_value(token, token_iterator)
        else
          # TODO create an appropriate error type
          raise "Unknown option: #{token}"
        end
      end
    end
  end
end
