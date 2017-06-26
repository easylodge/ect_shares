# veda.gemspec
# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ect_shares/version'

Gem::Specification.new do |spec|
  spec.name          = 'ect_shares'
  spec.version       = EctShares::VERSION
  spec.authors       = ['Jean le Roux']
  spec.email         = ['info@easylodge.com.au']
  spec.summary       = 'ECT shareholder information.'
  spec.description   = 'ECT shareholder allocations, pricing and detail'
  spec.homepage      = 'https://github.com/easylodge/ect_shares'
  spec.license       = 'None'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib', 'lib/ect_shares']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'rails', '~> 4.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'csv'
  spec.add_dependency 'activesupport'
end
