require "partner/version"
require "partner/option_template_library"
require "partner/configuration"
require "partner/parser"
require "logger"

module Partner
  class << self
    def configure(&block)
      option_template_library = OptionTemplateLibrary.new
      config = Configuration.new(option_template_library)
      yield(config)
      Parser.new(option_template_library)
    end

    def logger
      @logger ||= Logger.new($stdout).tap do |logger|
        logger.level = Logger::DEBUG
      end
    end
  end
end
