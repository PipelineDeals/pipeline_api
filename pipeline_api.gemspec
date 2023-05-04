# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require './lib/pipeline/version'

Gem::Specification.new do |gem|
  gem.name          = "pipeline"
  gem.version       = Pipeline::VERSION
  gem.authors       = ["Grant Ammons"]
  gem.email         = ["gammons@gmail.com"]
  gem.description   = %q{The pipeline gem is a ruby wrapper around the Pipeline API.}
  gem.summary   = %q{The pipeline gem is a ruby wrapper around the Pipeline API.}
  gem.homepage      = "https://github.com/Pipeline/pipeline_api"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency('activeresource')

  gem.add_development_dependency('rspec')
  gem.add_development_dependency('webmock')
  gem.add_development_dependency('vcr')
end
