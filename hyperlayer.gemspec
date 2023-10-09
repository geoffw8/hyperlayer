require_relative "lib/hyperlayer/version"

Gem::Specification.new do |spec|
  spec.name        = "hyperlayer"
  spec.version     = Hyperlayer::VERSION
  spec.authors     = ["Geoff Wright"]
  spec.email       = ["g746025@gmail.com"]
  spec.homepage    = "https://github.com/geoffw8/hyperlayer"
  spec.summary     = "Debug Ruby apps 10x faster."
  spec.description = "Debug Ruby apps 10x faster."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/geoffw8/hyperlayer"
  spec.metadata["changelog_uri"] = "https://github.com/geoffw8/hyperlayer"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Add dependencies
  spec.add_dependency "rails", ">= 7.0.8"
  spec.add_dependency 'json', '~> 2.3'
  spec.add_dependency 'redis', '~> 5.0.6'
  spec.add_dependency 'hashie', '~> 5.0'
  spec.add_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'bootstrap', '~> 5.1.3'
  spec.add_dependency 'pry'
end
