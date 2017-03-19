require "shellwords"
require "partner"
require "partner/error"

RSpec.describe Partner do
  let(:parser) { Partner::Parser.new }
  let(:args) { Shellwords.split(args_string) }
  let(:block) { ->(s){} }
  let(:args_string) { "" }

  describe "when a basic option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo
      }
    end

    it "gets a generated long name derived from the canonical name" do
      result = parser.parse(Shellwords.split("--foo"), &block)
      expect(result.option_values).to include(foo: true)
    end

    it "gets an expected generated short name" do
      result = parser.parse(Shellwords.split("-f"), &block)
      expect(result.option_values).to include(foo: true)
    end

    it "gets an expected default type" do
      result = parser.parse(Shellwords.split("--foo"), &block)
      expect(result.option_values).to include(foo: true)
    end

    context "with a long name" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, long: "--foo2"
        }
      end

      it "does not get a generated long name" do
        expect { parser.parse(Shellwords.split("--foo"), &block) }.to raise_error(Partner::UnknownOptionError)
      end

      it "recognises the given long name" do
        result = parser.parse(Shellwords.split("--foo2"), &block)
        expect(result.option_values).to include(foo: true)
      end

      context "which is invalid format" do
        let(:block) do
          ->(s){
            s.option canonical_name: :foo, long: "-foo2"
          }
        end

        it "raises an appropriate error" do
          expect { parser.parse(Shellwords.split("-foo2"), &block) }.to raise_error(Partner::InvalidLongOptionNameError)
        end
      end
    end

    context "with a short name" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, short: "-x"
        }
      end

      it "does not get a generated short name" do
        expect { parser.parse(Shellwords.split("-f"), &block) }.to raise_error(Partner::UnknownOptionError)
      end

      it "recognises the given short name" do
        result = parser.parse(Shellwords.split("-x"), &block)
        expect(result.option_values).to include(foo: true)
      end

      context "which is invalid format" do
        let(:block) do
          ->(s){
            s.option canonical_name: :foo, short: "-xx"
          }
        end

        it "raises an appropriate error" do
          expect { parser.parse(Shellwords.split("-xx"), &block) }.to raise_error(Partner::InvalidShortOptionNameError)
        end
      end
    end

    context "and an invalid long option is given" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("--foo2"), &block) }.to raise_error(Partner::UnknownOptionError)
      end
    end

    context "and an invalid short option is given" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("-x"), &block) }.to raise_error(Partner::UnknownOptionError)
      end
    end

    context "with a disabled short name" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, short: :none
        }
      end

      it "does not get a generated short name" do
        expect { parser.parse(Shellwords.split("-f"), &block) }.to raise_error(Partner::UnknownOptionError)
      end
    end
  end

  # a string option is configured
    # and an option argument is not given on the command line when using long name
      # it raises an appropriate error
    # and an option argument is not given on the command line when using short name
      # it raises an appropriate error
    # an an option argument is given on the command line when using long name
      # the result contains the option with the given value
    # an an option argument is given on the command line when using short name
      # the result contains the option with the given value
    # and it has a default value
      # and the option is not given on the command line at all
        # the result contains the option with the default value
        # the option is not marked as given
      # and the option is given on the command line
        # the result contains the option with the given value
        # the option is marked as given
    # and option argument is given on the command line via equals when using long name
      # the result contains the option with the given value
    # and option argument is given on the command line via equals when using short name
      # the result contains the option with the given value
    # and option argument is given on the command line using short option with value
      # the result contains the option with the given value
    # the option long name can't be negated
    # and it is configured to be required
      # and it is not given on the command line
        # it raises an appropriate error
    # and another string option is configured
      # and we attempt to give it the same long name as the first option
        # it raises an appropriate error
      # and we attempt to give it the same short name as the first option
        # it raises an appropriate error
  # an integer option is configured
    # an an option argument is given on the command line
      # the result contains the option with the given value
      # the value is of the appropriate type
    # and it has a type alias which is used for configuration
      # an an option argument is given on the command line
        # the result contains the option with the given value
        # the value is of the appropriate type
  # a float option is configured
    # an an option argument is given on the command line
      # the result contains the option with the given value
      # the value is of the appropriate type
  # a boolean option is configured
    # and another boolean option is configured
      # both boolean options can be given on the command line using combined format
      # the result contains both options with truthy values
      # both options are marked as given
    # and the option long name is given negated on the command line
      # the result contains the option with a falsy value
      # the option is marked as given
  # a terminator is given on the command line
    # all subsequent tokens are treated as arguments
  # an integer array option is configured
    # and the option argument is given on the command line via comma separated string
      # the result contains the option with the given values
      # all values in the list are of the appropriate type
    # and the option argument is given on the command line multiple times
      # the result contains the option with all the given values combined into a list
      # all values in the list are of the appropriate type
  # a single word command is configured
    # and the command is not given on the command line
      # it does not raise an error
    # and the command is given on the command line
      # the result contains the given command
  # a multi word command is configured
    # and the command is given with the words out of order
      # it raises an appropriate error
    # and the command is given with some of the words missing
      # it raises an appropriate error
end
