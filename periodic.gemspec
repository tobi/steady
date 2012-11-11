# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'periodic/version'

Gem::Specification.new do |gem|
  gem.name          = "periodic"
  gem.version       = Periodic::VERSION
  gem.authors       = ["Tobias Lutke"]
  gem.email         = ["tobi@shopify.com"]
  gem.description   = %q{Periodically run tasks that fetch data}
  gem.summary       = %q{Simple worker thread for periodic tasks}
  gem.homepage      = ""
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('speedytime')
end
