require "partner"
require "shellwords"

RSpec.describe Partner do
  let(:parser) { Partner::Parser.new }
  # let(:result) do
  #   Partner::Parser.new.parse(args, &block)
    # do |s|
      # s.option canonical_name: :foo, type: "integer", default: 55, required: true
      # s.option canonical_name: :foo2, type: "string", short: :none
      # s.option canonical_name: :bob, type: "boolean", short: "-b"
      # s.option canonical_name: :bar, type: "boolean"
      # s.option canonical_name: :combi, type: "string", short: "-m"
      # s.option canonical_name: :sss, type: "boolean", short: "-s"
      # s.option canonical_name: :ppp, type: "boolean", short: "-p"
      # s.option canonical_name: :qqq, type: "boolean", short: "-q"
      # s.option canonical_name: :baz, type: "string"
      # s.option canonical_name: :abc, type: "array[string]"
      # s.option canonical_name: :def, type: "array[integer]"
      # s.option canonical_name: :cleg, type: "string"
      # s.option canonical_name: :c, type: "string"
      # s.option canonical_name: :cred, type: "string"
      # s.command "tooty fruity"
      # s.command "feet\n"
      # s.command "feet are   really great"
    # end
  # end
  let(:args) { Shellwords.split(args_string) }
  let(:block) { ->(s){} }
  let(:args_string) { "" }

  describe "a basic option is configured" do
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

    context "when long name is given" do
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
    end

    context "when short name is given" do
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
    end

    context "when an unknown long option is given" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("--foo2"), &block) }.to raise_error(Partner::UnknownOptionError)
      end
    end

    context "when an unknown short option is given" do
      it "raises an appropriate error" do
        expect { parser.parse(Shellwords.split("-x"), &block) }.to raise_error(Partner::UnknownOptionError)
      end
    end

    context "when short name is disabled" do
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
end
