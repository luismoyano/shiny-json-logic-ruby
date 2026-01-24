
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "shiny_json_logic/version"

Gem::Specification.new do |spec|
  spec.name          = "shiny_json_logic"
  spec.version       = ShinyJsonLogic::VERSION
  spec.authors       = ["Luis Moyano"]
  spec.email         = ["moyano@hey.com"]

  spec.summary       = %q{An implementation of JSON Logic in Ruby that works.}
  spec.description   = %q{JsonLogic isn’t a full programming language. It’s a small, safe way to delegate one decision. You could store a rule in a database to decide later. You could send that rule from back-end to front-end so the decision is made immediately from user input. Because the rule is data, you can even build it dynamically from user actions or GUI input. See http://jsonlogic.com}
  spec.homepage      = "https://github.com/luismoyano/shiny-json-logic-ruby"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_runtime_dependency 'backport_dig' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3')
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'pry'
end
