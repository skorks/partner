require "partner/version"
require "partner/option_template_library"
require "partner/configuration"
require "partner/parser"
require "logger"

module Partner
  class << self
    def configure(&block)
      # TODO appropriately wrap in begin rescue end
      option_template_library = OptionTemplateLibrary.new
      config = Configuration.new(option_template_library)
      yield(config)
      Parser.new(option_template_library)
    end

    #TODO disable this when no longer needed for dev and we have good specs
    def logger
      @logger ||= Logger.new($stdout).tap do |logger|
        logger.level = Logger::DEBUG
      end
    end
  end
end
