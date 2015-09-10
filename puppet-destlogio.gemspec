# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'puppet/destlogio/version'

Gem::Specification.new do |spec|
  spec.name          = "puppet-destlogio"
  spec.version       = Puppet::DestLogIO::VERSION
  spec.authors       = ["DeathKing"]
  spec.email         = ["deathking0622@gmail.com"]

  spec.summary       = %q{Using Log.io as logging destinations.}
  spec.description   = %q{Using Log.io as logging destinations.}
  spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
