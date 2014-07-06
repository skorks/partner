require 'partner/option_template_finder/base'

module Partner
  module OptionTemplateFinder
    class ShortOption < Base
      def find_template_for(token)
        option_template_library.find_by_short_name(token).tap do |template|
          # TODO create an appropriate error type
          raise "Unknown option: #{token}" unless template
        end
      end
    end
  end
end
