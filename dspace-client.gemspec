# frozen_string_literal: true

require_relative "lib/dspace/client/version"

Gem::Specification.new do |spec|
  spec.name          = "dspace-client"
  spec.version       = DSpace::Client::VERSION
  spec.authors       = ["Mark Cooper"]
  spec.email         = ["mark.cooper@lyrasis.org"]

  spec.summary       = "DSpace REST API client"
  spec.description   = "DSpace REST API client"
  spec.homepage      = "https://github.com/DSpaceDirect/dspace-client"
  spec.required_ruby_version = ">= 2.4.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/DSpaceDirect/dspace-client"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "faraday", "~> 1.10"
  spec.add_dependency "faraday-cookie_jar"
  spec.add_dependency "faraday_middleware", "~> 1.2"
  spec.add_dependency "parallel", "~> 1.23"

  spec.add_development_dependency "debug", ">= 1.0.0"
  spec.add_development_dependency "minitest", ">= 5.0.5"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop", "~> 1.7"
  spec.add_development_dependency "ruby-debug-ide"
  spec.add_development_dependency "vcr", "~> 6.1"
end
