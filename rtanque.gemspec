# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtanque/version'

Gem::Specification.new do |gem|
  gem.name          = "rtanque"
  gem.version       = RTanque::VERSION
  gem.authors       = ["Adam Williams"]
  gem.email         = ["pwnfactory@gmail.com"]
  gem.description   = %q{Simple 2D tank game. Program your own tank to do battle with others.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/awilliams/RTanque"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'gosu'
  gem.add_dependency 'configuration'
  gem.add_dependency 'octokit'
  gem.add_dependency 'thor'
  gem.add_dependency 'texplay'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rspec-mocks'
end
