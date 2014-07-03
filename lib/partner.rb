require "partner/version"
require "partner/configuration"
require "partner/parser"

module Partner
  class << self
    def configure(&block)
      config = Configuration.new
      yield(config)
      Parser.new(config)
    end
  end
end
