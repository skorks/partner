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
    end
  end
end
