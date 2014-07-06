module Partner
  class OptionTemplate
    attr_reader :canonical_name, :type, :multi

    def initialize(canonical_name, options = {})
      @canonical_name = canonical_name
      @multi = options[:multi] || false
      @type = options[:type] || :string

      @possible_long_name = options[:long] || nil
      @long_name = nil

      @possible_short_name = options[:short] || nil
      @short_name = nil

      @possible_default_value = options[:default] || nil
      @default_value = nil
    end

    # TODO extract this logic into it's own class
    def long_name
      return @long_name if @long_name != nil
      if @possible_long_name
        @long_name = @possible_long_name
        raise "Long name must be a string: '#{@long_name}'" unless @long_name.kind_of?(String)
        @long_name = "--#{@long_name}" if @long_name.match(/^[^-]+/)
        raise "Long name '#{@long_name}' must contain only letters, numbers or dashes and should be preceeded with a double dash (e.g. --hello-world)" unless @long_name.match(/^--[a-zA-Z0-9]{1}[a-zA-Z0-9-]*/)
      else
        @long_name = "--#{dasherize(canonical_name)}"
      end
      @long_name
    end

    # TODO extract this logic into it's own class
    def short_name
      return @short_name if @short_name != nil
      if @possible_short_name
        @short_name = @possible_short_name
        raise "Short name must be a string: '#{@short_name}'" unless @short_name.kind_of?(String)
        @short_name = "-#{@short_name}" unless @short_name.start_with?('-')
        raise "Short name '#{@short_name}' must be a letter or a number preceeded with a dash (e.g. -k)" unless @short_name.slice(1, @short_name.size).match(/[a-zA-Z0-9]{1}/)
      end
      @short_name
    end

    # TODO extract this logic into it's own class
    def default_value
      return @default_value if @default_value != nil
      if type == :boolean
        @default_value = @possible_default_value || false
        raise "Boolean option must have boolean default value (true, false): #{canonical_name}" unless @default_value.is_a?(TrueClass) || @default_value.is_a?(FalseClass)
      end
      if multi
        @default_value = @possible_default_value || []
      end
      @default_value
    end

    private

    def dasherize(string)
      string.to_s.tr('_', '-')
    end
  end
end
