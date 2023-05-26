# frozen_string_literal: true

require "English"

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "./lib/pipeline"

Gem::Specification.new do |gem|
  gem.name          = "pipeline"
  gem.version       = Pipeline::VERSION
  gem.authors       = ["Scott Gibson"]
  gem.email         = ["sevgibson@gmail.com"]
  gem.description   = "The pipeline gem is a ruby wrapper around the Pipeline API."
  gem.summary       = "The pipeline gem is a ruby wrapper around the Pipeline API."
  gem.homepage      = "https://github.com/Pipeline/pipeline_api"

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.require_paths = ["lib"]
  gem.required_ruby_version = ">= 2.2.0"

  gem.add_dependency("activesupport")
  gem.add_dependency("httparty")

  gem.add_development_dependency("rspec")
  gem.add_development_dependency("vcr")
  gem.add_development_dependency("webmock")
  gem.metadata["rubygems_mfa_required"] = "true"
end
