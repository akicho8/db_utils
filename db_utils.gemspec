# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'db_utils/version'

Gem::Specification.new do |spec|
  spec.name          = "db_utils"
  spec.version       = DbUtils::VERSION
  spec.authors       = ["akicho8"]
  spec.email         = ["akicho8@gmail.com"]
  spec.description   = %q{db utils mysql octopus senyou}
  spec.summary       = %q{db utils}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"

  spec.add_dependency "activerecord"
  spec.add_dependency "rain_table"
  spec.add_dependency "mysql2"
  spec.add_dependency "sqlite3"
end
