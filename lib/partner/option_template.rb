require 'partner/option_template'

module Partner
  class OptionTemplate
    attr_reader :canonical_name, :type, :multi

    def initialize(canonical_name, options = {})
      @canonical_name = canonical_name
      @multi = options[:multi] || false
      @type = :string

      # this is too simplistic but will do for now
      @long_name = options[:long] || nil
      @short_name = options[:short] || nil
    end

    def long_name
      @long_name ||= "--#{dasherize(canonical_name)}"
    end

    private

    def dasherize(string)
      string.to_s.tr('_', '-')
    end
  end
end
