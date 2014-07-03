require 'partner/option_template'

module Partner
  class Configuration
    attr_reader :options

    def initialize
      @options = {}
    end

    def option(canonical_name, options = {})
      add_option(canonical_name.to_sym, options)
      self
    end

    private

    def add_option(canonical_name_sym, options)
      @options[canonical_name_sym] = OptionTemplate.new(canonical_name_sym, options)
    end
  end
end
