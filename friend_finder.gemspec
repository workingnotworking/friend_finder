# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'friend_finder/version'

Gem::Specification.new do |spec|
  spec.name          = "friend_finder"
  spec.version       = FriendFinder::VERSION
  spec.authors       = ["Rob Cameron"]
  spec.email         = ["cannikinn@gmail.com"]

  spec.summary       = %q{Pulls social media friends for use by WNW}
  spec.description   = %q{Pulls social media friends for use by WNW}
  spec.homepage      = "https://workingnotworking.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency "twitter"
end
