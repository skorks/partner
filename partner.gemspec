# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'partner/version'

Gem::Specification.new do |spec|
  spec.name          = "partner"
  spec.version       = Partner::VERSION
  spec.authors       = ["Alan Skorkin"]
  spec.email         = ["alan@skorks.com"]
  spec.description   = %q{Command line option parser}
  spec.summary       = %q{Command line option parser}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
