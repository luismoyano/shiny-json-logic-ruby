
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shiny_json_logic/version"

Gem::Specification.new do |spec|
  spec.name          = "shiny_json_logic"
  spec.version       = ShinyJsonLogic::VERSION
  spec.authors       = ["Luis Moyano"]
  spec.email         = ["moyano@hey.com"]

  spec.summary = "Production-ready JSON Logic for Ruby that just works: zero deps, Ruby 2.7+, high spec alignment."
  spec.description = %q{
    ShinyJsonLogic is a pure-Ruby, zero-runtime-dependency implementation of the JSON Logic specification. Ruby 2.7+ compatible, actively maintained, test-driven, and designed for strict spec alignment and predictable behavior. It currently offers the highest support for JSON Logic operations in the Ruby ecosystem.
  }

  spec.homepage      = "https://github.com/luismoyano/shiny-json-logic-ruby"
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => spec.homepage,
    "documentation_uri" => "#{spec.homepage}#readme",
    "changelog_uri" => "#{spec.homepage}/blob/master/CHANGELOG.md",
    "rubygems_mfa_required" => "true"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'ostruct'
end
