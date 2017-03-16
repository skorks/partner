module Partner
  class OptionValue
    attr_reader :raw

    def initialize(type)
      @raw = type.default_value
      @type = type
    end

    def update(value)
      if @raw.kind_of?(Array)
        @raw += @type.cast(value)
      else
        @raw = @type.cast(value)
      end
    end
  end
end
