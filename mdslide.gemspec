# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mdslide', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Allu Yamane"]
  gem.email         = ["ymrl@ymrl.net"]
  gem.description   = %q{HTML5 presentation generator}
  gem.summary       = %q{HTML5 presentation generator}
  gem.homepage      = "http://ymrl.github.com/mdslide/"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mdslide"
  gem.require_paths = ["lib"]
  gem.version       = Mdslide::VERSION
  gem.add_dependency 'args_parser', '>= 0.0.1'
  gem.add_dependency 'kramdown',    '>= 0.13.6'
  gem.add_development_dependency('rspec', '~> 2.10.0')
  gem.add_development_dependency('rake')
end
