require "partner/error"
require "partner/option_utils"

module Partner
  class Config
    attr_reader :existing_short_names, :options_requiring_short_names

    def initialize
      @options = []
      @options_index = {}
      # @options_by_canonical_name = {}
      # @options_by_short = {}
      # @options_by_long = {}
      @command_tree = {}
      @valid_commands = {}
      @valid_command_words = {}
      @existing_short_names = {}
      @options_requiring_short_names = []
    end

    def add_option(option_instance)
      ensure_long_name_format_valid(option_instance)
      ensure_short_name_format_valid(option_instance)
      ensure_no_canonical_name_conflict(option_instance)
      ensure_no_long_name_conflict(option_instance)
      ensure_no_short_name_conflict(option_instance)

      # @options << option_instance
      # index_option(option_instance)
      # index_by_canonical_name(option_instance)
      # index_by_long_name(option_instance)
      # index_by_short_name(option_instance)
      OptionIndexer.new(options_index: options_index).index(option_instance)
    end

    class OptionsIndex
      attr_reader :existing_short_names, :options_requiring_short_names
      attr_reader :options_with_defaults, :required_options

      def initialize
        @options = []
        @options_index = {}
        @existing_short_names = {}
        @options_requiring_short_names = []
        @options_with_defaults = []
        @required_options = []
      end

      def add(option_instance)
        @options << option_instance
        index_by_all_names(option_instance)
        index_by_all_aliases(option_instance)
        index_by_short_name(option_instance)
      end

      def contains?(key)
        @options_index.has_key?(key.to_s)
      end

      private

      def index_by_all_names(option_instance)
        option_instance.all_names.each do |option_alias|
          @options_index[option_alias] = option_instance
        end
      end

      def index_by_all_aliases(option_instance)
        option_instance.all_aliases.each do |option_alias|
          next if @options_index.has_key?(option_alias)
          @options_index[option_alias] = option_instance
        end
      end

      def index_by_short_name(option_instance)
        if option_instance.has_short_name?
          @existing_short_names[option_instance.short.to_s] = true
        else
          @options_requiring_short_names << option_instance if option_instance.needs_short_name?
        end
      end
    end

    class OptionsIndexer
      attr_reader :options_index

      def initialize(options_index:)
        @options_index = options_index
      end

      def index(option_instance)
        consistency_checks.each do |check_class|
          check_class.new(options_index: options_index, option_instance: option_instance).execute
        end
        options_index.add(option_instance)
      end

      def consistency_checks
        [
          ConsistencyCheck::LongNameFormatValid,
          ConsistencyCheck::ShortNameFormatValid,
          ConsistencyCheck::NoCanonicalNameConflict,
          ConsistencyCheck::NoLongNameConflict,
          ConsistencyCheck::NoShortNameConflict,
        ]
      end

      module ConsistencyCheck
        class Base
          attr_reader :options_index, :option_instance

          def initialize(options_index:, option_instance:)
            @options_index = options_index
            @option_instance = option_instance
          end

          def execute
            raise "Not Implemented"
          end
        end

        class LongNameFormatValid
          def execute
            if option_instance.long && !OptionUtils.long_name_format_valid?(option_instance.long)
              raise InvalidLongOptionNameError.new(option_instance.long)
            end
          end
        end

        class ShortNameFormatValid
          def execute
            if option_instance.has_short_name? && !OptionUtils.short_name_format_valid?(option_instance.short)
              raise InvalidShortOptionNameError.new(option_instance.short)
            end
          end
        end

        class NoCanonicalNameConflict
          def execute
            if options_index.contains?(option_instance.canonical_name.to_s)
              raise ConflictingCanonicalOptionNameError.new(option_instance.canonical_name)
            end
          end
        end

        class NoLongNameConflict
          def execute
            if options_index.contains?(option_instance.long.to_s)
              raise ConflictingLongOptionNameError.new(option_instance.long)
            end
          end
        end

        class NoShortNameConflict
          def execute
            if option_instance.has_short_name? && options_index.contains?(option_instance.short.to_s)
              raise ConflictingShortOptionNameError.new(option_instance.short)
            end
          end
        end
      end
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

    def update_short_name_index(option_instance)
      index_by_short_name(option_instance)
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
      return true unless command_string
      @valid_commands.has_key?(command_string)
    end

    def options_with_defaults
      @options.reduce([]) do |acc, option_instance|
        acc << option_instance if option_instance.default
        acc
      end
    end

    def required_options
      @options.reduce([]) do |acc, option_instance|
        acc << option_instance if option_instance.required
        acc
      end
    end

    def valid_option?(token)
      !!@options_index[token.to_s]
    end

    private

    # def index_option(option_instance)
    #   index_by_all_names(option_instance)
    #   index_by_all_aliases(option_instance)
    #   index_by_short_name(option_instance)
    # end
    #
    # def index_by_all_names(option_instance)
    #   option_instance.all_names.each do |option_alias|
    #     @options_index[option_alias] = option_instance
    #   end
    # end
    #
    # def index_by_all_aliases(option_instance)
    #   option_instance.all_aliases.each do |option_alias|
    #     next if @options_index.has_key?(option_alias)
    #     @options_index[option_alias] = option_instance
    #   end
    # end
    #
    # def index_by_short_name(option_instance)
    #   if option_instance.has_short_name?
    #     @existing_short_names[option_instance.short.to_s] = true
    #   else
    #     @options_requiring_short_names << option_instance if option_instance.needs_short_name?
    #   end
    # end
    #
    # def ensure_long_name_format_valid(option_instance)
    #   if option_instance.long && !OptionUtils.long_name_format_valid?(option_instance.long)
    #     raise InvalidLongOptionNameError.new(option_instance.long)
    #   end
    # end
    #
    # def ensure_short_name_format_valid(option_instance)
    #   if option_instance.has_short_name? && !OptionUtils.short_name_format_valid?(option_instance.short)
    #     raise InvalidShortOptionNameError.new(option_instance.long)
    #   end
    # end
    #
    # def ensure_no_canonical_name_conflict(option_instance)
    #   if @options_index.has_key?(option_instance.canonical_name.to_s)
    #     raise ConflictingCanonicalOptionNameError.new(option_instance.canonical_name)
    #   end
    # end
    #
    # def ensure_no_long_name_conflict(option_instance)
    #   if @options_index.has_key?(option_instance.long.to_s)
    #     raise ConflictingLongOptionNameError.new(option_instance.long)
    #   end
    # end
    #
    # def ensure_no_short_name_conflict(option_instance)
    #   if option_instance.has_short_name? && @options_index.has_key?(option_instance.short.to_s)
    #     raise ConflictingShortOptionNameError.new(option_instance.short)
    #   end
    # end
  end
end
