# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbahocorasick/version'

Gem::Specification.new do |gem|
  gem.name          = "rbahocorasick"
  gem.version       = RBAhoCorasick::VERSION
  gem.authors       = ["Changli Gao"]
  gem.email         = ["xiaosuo@gmail.com"]
  gem.description   = %q{A Ruby implementation of the Aho-Corasick string matching algorithm}
  gem.summary       = %q{A Ruby implementation of the Aho-Corasick string matching algorithm}
  gem.homepage      = "https://github.com/xiaosuo/rbahocorasick"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.license       = 'MIT'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
end
