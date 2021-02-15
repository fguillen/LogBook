# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'log_book/version'

Gem::Specification.new do |spec|
  spec.name          = "log_book"
  spec.version       = LogBook::VERSION
  spec.authors       = ["Fernando Guillen"]
  spec.email         = ["fguillen.mail@gmail.com"]
  spec.description   = "Storing an events log book"
  spec.summary       = "Storing an events log book"
  spec.homepage      = "https://github.com/DaliaResearch/LogBook"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rails"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "assert_difference"
  spec.add_development_dependency "minitest"
end
