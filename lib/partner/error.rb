module Partner
  class Error < StandardError; end
  class InputError < Error; end
  class UnknownOptionError < InputError; end
  class MissingOptionArgumentError < InputError; end
  class InvalidOptionArgumentError < InputError; end
  class InvalidCommandError < InputError; end
  class RequiredOptionsMissingError < InputError; end
  class ConflictingCanonicalOptionNameError < InputError; end
  class ConflictingLongOptionNameError < InputError; end
  class ConflictingShortOptionNameError < InputError; end
end
