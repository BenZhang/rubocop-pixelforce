lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubocop/pixelforce/version'

Gem::Specification.new do |spec|
  spec.name          = 'rubocop-pixelforce'
  spec.version       = Rubocop::Pixelforce::VERSION
  spec.authors       = ['Ben Zhang']
  spec.email         = ['bzbnhang@gmail.com']

  spec.summary       = 'Custom Rubocop cop for PixelForce.'
  spec.description   = "Use empty lines between categories and Don't Use empty lines between same categories."
  spec.homepage      = 'https://github.com/BenZhang/rubocop-pixelforce'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/BenZhang/rubocop-pixelforce'
  spec.metadata['changelog_uri'] = 'https://github.com/BenZhang/rubocop-pixelforce'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'

  spec.add_runtime_dependency 'rubocop', '~> 1.75'
  spec.add_runtime_dependency 'rubocop-performance'
  spec.add_runtime_dependency 'rubocop-rails'
end
