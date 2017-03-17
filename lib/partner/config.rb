require "partner/error"

module Partner
  class Config
    attr_reader :existing_short_names, :options_requiring_short_names

    def initialize
      @options_by_canonical_name = {}
      @options_by_short = {}
      @options_by_long = {}
      @command_tree = {}
      @valid_commands = {}
      @valid_command_words = {}
      @existing_short_names = {}
      @options_requiring_short_names = []
    end

    def add_option(option_instance)
      index_by_canonical_name(option_instance)
      index_by_long_name(option_instance)
      index_by_short_name(option_instance)
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

    def update_short_hash
      @options_by_short[option.short] = option if option.short
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

    def options_with_defaults
      @options_by_canonical_name.keys.reduce([]) do |acc, key|
        acc << @options_by_canonical_name[key] if @options_by_canonical_name[key].default
        acc
      end
    end

    def required_options
      @options_by_canonical_name.keys.reduce([]) do |acc, key|
        acc << @options_by_canonical_name[key] if @options_by_canonical_name[key].required
        acc
      end
    end

    private

    def has_short_name?(option_instance)
      option_instance.short && option_instance.short != :none
    end

    def index_by_canonical_name(option_instance)
      if @options_by_canonical_name.has_key?(option_instance.canonical_name)
        raise ConflictingCanonicalOptionNameError.new(option_instance.canonical_name)
      else
        @options_by_canonical_name[option_instance.canonical_name] = option_instance
      end
    end

    def index_by_long_name(option_instance)
      if @options_by_long.has_key?(option_instance.long)
        raise ConflictingLongOptionNameError.new(option_instance.long)
      else
        @options_by_long[option_instance.long] = option_instance
      end
    end

    def index_by_short_name(option_instance)
      if has_short_name?(option_instance)
        if @options_by_short.has_key?(option_instance.short)
          raise ConflictingShortOptionNameError.new(option_instance.short)
        else
          @options_by_short[option_instance.short] = option_instance
          @existing_short_names[option_instance.short] = true
        end
      else
        @options_requiring_short_names << option_instance
      end
    end
  end
end
