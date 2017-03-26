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

  describe "when a string option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "string", short: "-f"
      }
    end

    context "and an option argument is not given on the command line when using long name" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("--foo"), &block) }.to raise_error(Partner::MissingOptionArgumentError)
      end
    end

    context "and an option argument is not given on the command line when using short name" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("-f"), &block) }.to raise_error(Partner::MissingOptionArgumentError)
      end
    end

    context "an an option argument is given on the command line when using long name" do
      it "the result contains the option with the given value" do
        result = parser.parse(Shellwords.split("--foo blah"), &block)
        expect(result.option_values).to include(foo: "blah")
      end
    end

    context "an an option argument is given on the command line when using short name" do
      it "the result contains the option with the given value" do
        result = parser.parse(Shellwords.split("-f blah"), &block)
        expect(result.option_values).to include(foo: "blah")
      end
    end

    context "type is given as a symbol" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: :string, short: "-f"
        }
      end

      it "the result contains the option with the given value" do
        result = parser.parse(Shellwords.split("-f blah"), &block)
        expect(result.option_values).to include(foo: "blah")
      end
    end

    context "and it has a default value" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "string", short: "-f", default: "hello"
        }
      end

      context "and the option is not given on the command line" do
        let(:result) { parser.parse(Shellwords.split(""), &block) }

        it "the result contains the option with the default value" do
          expect(result.option_values).to include(foo: "hello")
        end

        it "the option is not marked as given" do
          expect(result.given_options).to_not include(foo: true)
        end
      end

      context "and the option is given on the command line" do
        let(:result) { parser.parse(Shellwords.split("-f 'yadda'"), &block) }

        it "the result contains the option with the given value" do
          expect(result.option_values).to include(foo: "yadda")
        end

        it "the option is marked as given" do
          expect(result.given_options).to include(foo: true)
        end
      end
    end

    context "and option argument is given on the command line via equals when using long name" do
      let(:result) { parser.parse(Shellwords.split("--foo='yadda 123'"), &block) }

      it "the result contains the option with the given value" do
        expect(result.option_values).to include(foo: "yadda 123")
      end
    end

    context "and option argument is given on the command line via equals when using short name" do
      let(:result) { parser.parse(Shellwords.split("-f='yadda 123 234'"), &block) }

      it "the result contains the option with the given value" do
        expect(result.option_values).to include(foo: "yadda 123 234")
      end
    end

    context "and option argument is given on the command line using short option with value" do
      let(:result) { parser.parse(Shellwords.split("-fbar"), &block) }

      it "the result contains the option with the given value" do
        expect(result.option_values).to include(foo: "bar")
      end
    end

    it "the option long name can't be negated" do
      expect { parser.parse(Shellwords.split("--no-foo"), &block) }.to raise_error(Partner::InvalidOptionNegationError)
    end

    context "and it is configured to be required" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "string", short: "-f", default: "hello", required: true
        }
      end

      context "and an option argument is not given on the command line" do
        it "raises an appropriate error" do
          expect { parser.parse(Shellwords.split(""), &block) }.to raise_error(Partner::RequiredOptionsMissingError)
        end
      end
    end

    context "and another string option is configured" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "string", short: "-f", default: "hello", required: true
          s.option canonical_name: :bar, type: "string"
        }
      end

      context "and we attempt to give it the same long name as the first option" do
        let(:block) do
          ->(s){
            s.option canonical_name: :foo, type: "string", long: "--foo", short: "-f", default: "hello", required: true
            s.option canonical_name: :bar, type: "string", long: "--foo"
          }
        end

        it "raises an appropriate error" do
          expect { parser.parse(Shellwords.split(""), &block) }.to raise_error(Partner::ConflictingLongOptionNameError)
        end
      end

      context "and we attempt to give it the same short name as the first option" do
        let(:block) do
          ->(s){
            s.option canonical_name: :foo, type: "string", long: "--foo", short: "-f", default: "hello", required: true
            s.option canonical_name: :bar, type: "string", short: "-f"
          }
        end

        it "raises an appropriate error" do
          expect { parser.parse(Shellwords.split(""), &block) }.to raise_error(Partner::ConflictingShortOptionNameError)
        end
      end
    end
  end

  context "when an integer option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "integer"
      }
    end

    context "and an option argument is given on the command line" do
      let(:result) { parser.parse(Shellwords.split("--foo 234"), &block) }

      it "the result contains the option with the given value" do
        expect(result.option_values).to include(foo: 234)
      end

      it "the value is of the appropriate type" do
        expect(result.option_values[:foo].class).to eq Integer
      end
    end

    context "and it has a type alias which is used for configuration" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "i"
        }
      end

      context "and an option argument is given on the command line" do
        let(:result) { parser.parse(Shellwords.split("--foo 234"), &block) }

        it "the result contains the option with the given value" do
          expect(result.option_values).to include(foo: 234)
        end

        it "the value is of the appropriate type" do
          expect(result.option_values[:foo].class).to eq Integer
        end
      end
    end
  end

  context "when a float option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "float"
      }
    end

    context "and an option argument is given on the command line" do
      let(:result) { parser.parse(Shellwords.split("--foo 2.34"), &block) }

      it "the result contains the option with the given value" do
        expect(result.option_values).to include(foo: 2.34)
      end

      it "the value is of the appropriate type" do
        expect(result.option_values[:foo].class).to eq Float
      end
    end
  end

  context "when a boolean option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "bool"
      }
    end

    context "and another boolean option is configured" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "bool"
          s.option canonical_name: :bar, type: "b"
        }
      end
      let(:result) { parser.parse(Shellwords.split("-fb"), &block) }

      it "the result contains both options with truthy values" do
        expect(result.option_values).to include(foo: true, bar: true)
      end

      it "both options are marked as given" do
        expect(result.given_options).to include(foo: true, bar: true)
      end
    end

    context "and the option long name is given negated on the command line" do
      let(:block) do
        ->(s){
          s.option canonical_name: :foo, type: "boolean"
        }
      end
      let(:result) { parser.parse(Shellwords.split("--no-foo"), &block) }

      it "the result contains the options with a falsy values" do
        expect(result.option_values).to include(foo: false)
      end

      it "the option is marked as given" do
        expect(result.given_options).to include(foo: true)
      end
    end
  end

  describe "when a terminator is given on the command line" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "boolean"
      }
    end
    let(:result) { parser.parse(Shellwords.split("--foo -- --bar -b"), &block) }

    it "all subsequent tokens are treated as arguments" do
      expect(result.arguments).to include("--bar", "-b")
    end
  end

  describe "when an integer array option is configured" do
    let(:block) do
      ->(s){
        s.option canonical_name: :foo, type: "array[int]"
      }
    end

    context "and the option argument is given on the command line via comma separated string" do
      let(:result) { parser.parse(Shellwords.split("-f 3,33,45"), &block) }

      it "the result contains the option with the given values" do
        expect(result.option_values).to include(foo: [3,33,45])
      end
    end

    context "and the option argument is given on the command line via comma separated string" do
      let(:result) { parser.parse(Shellwords.split("-f 3,33,45 --foo 87"), &block) }

      it "the result contains the option with the given values" do
        expect(result.option_values).to include(foo: [3,33,45,87])
      end
    end
  end

  describe "when a single word command is configured" do
    let(:block) do
      ->(s){
        s.command "hello"
      }
    end

    context "and the command is not given on the command line" do
      it "does not raise an error" do
        expect{ parser.parse(Shellwords.split(""), &block) }.to_not raise_error
      end
    end

    context "and the command is given on the command line" do
      let(:result) { parser.parse(Shellwords.split("hello"), &block) }

      it "the result contains the given command" do
        expect(result.command).to eq "hello"
      end
    end
  end

  describe "when a multi word command is configured" do
    let(:block) do
      ->(s){
        s.command "hello world foo"
      }
    end

    context "and the command is given with the words out of order" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("hello foo world"), &block) }.to raise_error(Partner::InvalidCommandError)
      end
    end

    context "and the command is given with some of the words missing" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("hello world"), &block) }.to raise_error(Partner::InvalidCommandError)
      end
    end
  end

  describe "when a version option is configured" do
    let(:block) do
      ->(s){
        s.version "abc123"
      }
    end

    exit_exception = nil
    before do
      $stdout = StringIO.new
      begin
        result
      rescue SystemExit => e
        exit_exception = e
      end
      $stdout.rewind
    end

    context "and the option is given on the command line" do
      let(:result) { parser.parse(Shellwords.split("--version"), &block) }

      it "prints out the version string" do
        expect($stdout.read.strip).to eq "abc123"
      end

      it "exits" do
        expect(exit_exception).to_not be_nil
      end

      it "exits successfully" do
        expect(exit_exception.status).to eq 0
      end
    end

    context "using a regular option with a handler" do
      let(:result) { parser.parse(Shellwords.split("--version"), &block) }
      let(:block) do
        ->(s){
          s.option canonical_name: :version, handler: Partner::OptionHandler::VersionHandler.new("abc123")
        }
      end

      it "prints out the version string" do
        expect($stdout.read.strip).to eq "abc123"
      end

      it "exits" do
        expect(exit_exception).to_not be_nil
      end

      it "exits successfully" do
        expect(exit_exception.status).to eq 0
      end
    end
  end
end
