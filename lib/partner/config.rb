module Partner
  class Config
    def initialize
      @options_by_canonical_name = {}
      @options_by_short = {}
      @options_by_long = {}
      @command_tree = {}
      @valid_commands = {}
      @valid_command_words = {}
    end

    def add_option(option)
      @options_by_canonical_name[option.canonical_name] = option
      @options_by_long[option.long] = option
      @options_by_short[option.short] = option if option.short
    end

    def add_command(command_string)
      command_words = command_string.split(/\s+/)
      @valid_commands[command_words.join(" ")] = true

      current_hash = @command_tree
      command_words.each_with_index do |command_word, index|
        @valid_command_words[command_word] = true
        if index >= command_words.length - 1
          current_hash[command_word] = nil
        else
          current_hash[command_word] ||= {}
          current_hash = current_hash[command_word]
        end
      end
    end

    def find_option_by_long(token)
      @options_by_long[token]
    end

    def find_option_by_short(token)
      @options_by_short[token]
    end

    def valid_command_word?(token)
      @valid_command_words[token]
    end

    def valid_command_word_order?(token, current_command_word_list)
      current_hash = @command_tree
      current_command_word_list.each do |command_word|
        current_hash = current_hash[command_word] || {}
      end
      current_hash.has_key?(token)
    end

    def valid_command?(command_string)
      @valid_commands.has_key?(command_string)
    end
  end
end
