require 'partner/option_template'

module Partner
  class OptionTemplateLibrary
    include Enumerable

    attr_reader :by_canonical_name, :by_long_name, :by_short_name

    def initialize
      @by_canonical_name = {}
      @by_long_name = {}
      @by_short_name = {}
    end

    def each(&block)
      by_canonical_name.each_value do |option_template|
        yield(option_template) if block_given?
      end
    end

    def add(canonical_name, options = {})
      canonical_name_sym = canonical_name.to_sym
      template = OptionTemplate.new(canonical_name_sym, options)
      by_canonical_name[canonical_name_sym] = template
      by_long_name[template.long_name] = template if template.long_name
      by_short_name[template.short_name] = template if template.short_name
    end

    def find_by_long_name(name)
      by_long_name[name]
    end
  end
end
