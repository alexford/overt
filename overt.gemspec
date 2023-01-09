# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'overt/version'

Gem::Specification.new do |spec|
  spec.name          = 'overt'
  spec.licenses      = ['MIT']
  spec.version       = Overt::VERSION
  spec.authors       = ['Alex Ford']
  spec.email         = ['alexford@hey.com']
  spec.required_ruby_version = '>= 3.0.0'

  spec.summary       = 'The static site generator I want to use'
  spec.homepage      = 'https://github.com/alexford/overt'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'yard', '~> 0.9'

  spec.add_dependency 'formatador'
  spec.add_dependency 'kramdown'
  spec.add_dependency 'thor'
  spec.add_dependency 'tilt'
  spec.add_dependency 'async'
  spec.add_dependency 'zeitwerk'
end
