module Partner
  module OptionTypes
    class Base
      def name
        self.class.name.downcase.split("::").last.gsub("type", "")
      end

      def name_aliases
        []
      end

      def requires_argument?
        true
      end

      def cast(value)
        value
      end

      def default_value
        nil
      end
    end
  end
end
