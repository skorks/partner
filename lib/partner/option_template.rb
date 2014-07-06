module Partner
  class OptionTemplate
    attr_reader :canonical_name, :type, :multi

    def initialize(canonical_name, options = {})
      @canonical_name = canonical_name
      @multi = options[:multi] || false
      @type = options[:type] || :string

      # this is too simplistic but will do for now
      @long_name = options[:long] || nil
      @short_name = options[:short] || nil

      @possible_default_value = options[:default] || nil
      @default_value = nil
    end

    def long_name
      @long_name ||= "--#{dasherize(canonical_name)}"
    end

    def short_name
      # if it doesn't start with dash add the dash
      # if it is longer than 1 character originally ??? raise error
      @short_name
    end

    def default_value
      return @default_value if @default_value
      if type == :boolean
        @default_value = @possible_default_value || false
        raise "Boolean option must have boolean default value (true, false): #{canonical_name}" unless @default_value.is_a?(TrueClass) || @default_value.is_a?(FalseClass)
      end
      @default_value
    end

    private

    def dasherize(string)
      string.to_s.tr('_', '-')
    end
  end
end
