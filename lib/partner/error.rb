module Partner
  class Error
    class InputError < StandardError
    end

    class UnknownOptionError < InputError
    end

    class MissingOptionArgumentError < InputError
    end

    class InvalidOptionArgumentError < InputError
    end

    class InvalidCommandError < InputError
    end
  end
end
