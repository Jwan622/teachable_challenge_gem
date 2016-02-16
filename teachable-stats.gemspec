# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teachable/stats/version'

Gem::Specification.new do |spec|
  spec.name          = "teachable-stats"
  spec.version       = Teachable::Stats::VERSION
  spec.authors       = ["Jeffrey Wan"]
  spec.email         = ["Jwan622@gmail.com"]

  spec.summary       = %q{This is a wrapper for the mock Teachable API}
  spec.description   = %q{The teachable-stats gem is a wrapper for the Teachable API. Hopefully this saves you time!}
  spec.homepage      = "https://github.com/Jwan622/teachable_challenge_gem"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"

  spec.add_dependency "rest-client"
  spec.add_dependency "json"
end
