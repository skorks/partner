module Partner
  class CliTokenIterator
    attr_reader :argv

    def initialize(argv)
      @argv = argv || []
      @current_index = 0
    end

    def next
      argv[@current_index].tap do |token|
        @current_index += 1
      end
    end
  end
end
