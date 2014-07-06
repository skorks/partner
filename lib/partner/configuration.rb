module Partner
  class Configuration
    def initialize(option_template_library)
      @option_template_library = option_template_library
    end

    def option(canonical_name, options = {})
      @option_template_library.add(canonical_name, options)
      self
    end
  end
end
