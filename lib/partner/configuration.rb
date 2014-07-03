require 'partner/option_template'

module Partner
  class Configuration
    attr_reader :options

    def initialize
      @options = {}
    end

    def option(canonical_name, options = {})
      canonical_name_sym = canonical_name.to_sym
      options[canonical_name_sym] = OptionTemplate.new(canonical_name_sym, options)
      self
    end
  end
end
