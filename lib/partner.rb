require "partner/version"

require "partner/config"
require "partner/option"

require "partner/parser"

module Partner
  class << self
    attr_accessor :logger
    attr_accessor :extra_option_types
    attr_accessor :extra_token_types
    attr_accessor :extra_pre_parsing_steps
    attr_accessor :extra_post_parsing_steps
  end
end
