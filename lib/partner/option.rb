module Partner
  class Option
    attr_reader :template, :value

    def initialize(template)
      @template = template
      @value = template.default_value
      @given = false
    end

    def add_value(token, token_iterator)
      @value = token_iterator.next
      @given = true
      unless @value
        # TODO raise appropriate error
        raise "No value found for option: #{token}"
      end
      self
    end

    def name
      template.canonical_name
    end

    def given?
      @given
    end
  end
end
