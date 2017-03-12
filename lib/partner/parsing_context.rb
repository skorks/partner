require "partner/result"

module Partner
  class ParsingContext
    attr_reader :config, :result, :token_iterator
    attr_reader :locked_token_processor_class

    def initialize(config:, result: Result.new, token_iterator:)
      @config = config
      @result = result
      @token_iterator = token_iterator
      @locked_token_processor_class = nil
    end

    def lock_token_type(token_processor_class:)
      @locked_token_processor_class = token_processor_class
    end

    def token_type_locked?
      locked_token_processor_class != nil
    end
  end
end
