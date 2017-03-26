require "partner/version"

require "partner/config"
require "partner/option"

require "partner/parser"
require "partner/error"

require "partner/option_handler/terminating_handler"
require "partner/option_handler/non_terminating_handler"
require "partner/option_handler/version_handler"

module Partner
  class << self
    attr_accessor :logger
    attr_accessor :extra_option_types
    attr_accessor :extra_token_types
    attr_accessor :extra_pre_parsing_steps
    attr_accessor :extra_post_parsing_steps
  end
end
