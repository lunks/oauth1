# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'oauth1/version'

Gem::Specification.new do |spec|
  spec.name          = "oauth1"
  spec.version       = OAuth1::VERSION
  spec.authors       = ["Matheus Bras", "Pedro Nascimento"]
  spec.email         = ["matheus@helabs.com.br", "pedro@helabs.com.br"]
  spec.description   = %q{Simple OAuth 1.0 Helper to generate URLs with HMAC-SHA1 encoding.}
  spec.summary       = %q{In case you need to craft an OAuth 1.0 URL with HMAC-SHA1, this may be helpful.}
  spec.homepage      = "http://helabs.com.br/opensource"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.2"
  spec.add_dependency "addressable"
  spec.add_dependency "activesupport", "> 3.0.11"
end
