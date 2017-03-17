# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpd/version'

Gem::Specification.new do |spec|
  spec.name          = "rpd"
  spec.version       = Rpd::VERSION
  spec.authors       = ["MGSX"]
  spec.email         = ["info@mgsx.net"]

  spec.summary       = %q{Puredata ruby library.}
  spec.description   = %q{Interact with Puredata with ruby.}
  spec.homepage      = "https://github.com/mgsx-dev/rpd"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
