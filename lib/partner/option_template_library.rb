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
      store_by_canonical_name(template)
      store_by_long_name(template)
      store_by_short_name(template)
    end

    def find_by_long_name(name)
      by_long_name[name]
    end

    def find_by_short_name(name)
      by_short_name[name]
    end

    private

    def store_by_canonical_name(template)
      if by_canonical_name[template.canonical_name]
        # TODO better error
        raise "Option named '#{template.canonical_name}' already exists"
      else
        by_canonical_name[template.canonical_name] = template
      end
    end

    def store_by_long_name(template)
      if template.long_name
        if by_long_name[template.long_name]
          # TODO better error
          raise "Long name '#{template.long_name}' already exists"
        else
          by_long_name[template.long_name] = template
        end
      end
    end

    def store_by_short_name(template)
      if template.short_name
        if by_short_name[template.short_name]
          # TODO better error
          raise "Short name '#{template.short_name}' already exists"
        else
          by_short_name[template.short_name] = template
        end
      end
    end
  end
end
