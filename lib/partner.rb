require "partner/version"
require "partner/configuration"
require "partner/parser"
require "logger"

module Partner
  class << self
    def configure(&block)
      config = Configuration.new
      yield(config)
      Parser.new(config)
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |logger|
        logger.level = Logger::DEBUG
      end
    end
  end
end
