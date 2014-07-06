module Partner
  class Option
    attr_reader :template

    def initialize(template, value = nil, given = false)
      @template = template
      @potential_value = value
      @value = nil
      @given = given
    end

    def name
      template.canonical_name
    end

    # the actual value can be false for boolean options so we need to have
    # a clear distinction between a value that is false and on that's nil
    def value
      return @value if @value != nil
      if @potential_value == nil
        @value = template.default_value
      elsif template.multi
        @value = [@potential_value]
      else
        @value = @potential_value
      end
    end

    def value=(value)
      @value = value
    end

    def given?
      @given
    end
  end
end
