module Partner
  class OptionUtils
    class << self
      def long_name_from_canonical_name(canonical_name)
        partial_long = canonical_name.to_s.gsub("_", "-")
        "--#{partial_long}"
      end

      def negated_long_name_from_long_name(long_name)
        long_name.sub("--", "--no-")
      end

      def long_name_from_negated_long_name(negated_long_name)
        negated_long_name.sub("--no-", "--")
      end

      def generate_possible_short_names(canonical_name)
        best_chars = canonical_name.to_s.gsub("_", "")
        best_chars = (best_chars + best_chars.upcase).split("")
        all_chars = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
        (best_chars + all_chars).map { |value| "-#{value}" }
      end

      def generate_short_name(possible_short_names, existing_short_names)
        generated_short_name = nil
        all_short_names = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten.map { |value| "-#{value}" }
        (possible_short_names + all_short_names).each do |short_name|
          unless existing_short_names[short_name]
            generated_short_name = short_name
            existing_short_names[short_name] = true
            break
          end
        end
        generated_short_name
      end

      def long_name_format_valid?(long_name)
        !!/^--[0-9a-zA-Z-]+$/.match(long_name)
      end

      def short_name_format_valid?(short_name)
        !!/^-[0-9a-zA-Z-]{1}$/.match(short_name)
      end
    end
  end
end
