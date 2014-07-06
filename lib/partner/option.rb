module Partner
  class Option
    attr_reader :template, :value

    def initialize(template)
      @template = template
      @value = template.default_value
      @given = false
    end

    def add_value(token, token_iterator)
      if template.type == :boolean
        @value = true
      else
        @value = token_iterator.next
      end
      @given = true
      # TODO raise appropriate error
      raise "No value found for option: #{token}" unless @value
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
