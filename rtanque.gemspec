# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtanque/version'

Gem::Specification.new do |gem|
  gem.name          = "rtanque"
  gem.version       = RTanque::VERSION
  gem.authors       = ["Adam Williams"]
  gem.email         = ["pwnfactory@gmail.com"]
  gem.summary       = %q{RTanque is a game for programmers. Players program the brain of a tank and then send their tank into battle against other tanks.}
  gem.description   = %q{RTanque is a game for programmers. Players program the brain of a tank and then send their tank+brain into battle with other tanks. All tanks are otherwise equal.

Rules of the game are simple: Last bot standing wins. Gameplay is also pretty simple. Each tank has a base, turret and radar, each of which rotate independently. The base moves the tank, the turret has a gun mounted to it which can fire at other tanks, and the radar detects other tanks in its field of vision.

Have fun competing against friends' tanks or the sample ones included. Maybe you'll start a small league at your local Ruby meetup.} 
  gem.homepage      = "https://github.com/awilliams/RTanque"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'gosu', '~> 1.0.0'
  gem.add_dependency 'configuration', '~> 1.3.4'
  gem.add_dependency 'octokit', '~> 4.15.0'
  gem.add_dependency 'thor', '~> 1.4.0'
  gem.add_dependency 'texplay', '>= 0.4.4pre'

  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rspec', '~> 3.7.0'
end
