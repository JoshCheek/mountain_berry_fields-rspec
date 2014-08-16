# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Josh Cheek"]
  gem.email         = ["josh.cheek@gmail.com"]
  gem.description   = %q{When testing embedded code examples with MountainBerryFields, you may wish to use RSpec. This enables that integration}
  gem.summary       = %q{MountainBerryFields strategy for RSpec}
  gem.homepage      = "https://github.com/JoshCheek/mountain_berry_fields-rspec"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mountain_berry_fields-rspec"
  gem.require_paths = ["lib"]
  gem.version       = '1.0.3'

  gem.add_runtime_dependency 'deject',                '~> 0.2.2'
  gem.add_runtime_dependency 'rspec',                 '~> 3'
  gem.add_runtime_dependency 'mountain_berry_fields', '~> 1.0.2'

  gem.add_development_dependency 'surrogate',         '~> 0.8.0'
  gem.add_development_dependency 'cucumber',          '~> 1.3.0'
  gem.add_development_dependency 'rake'
end
