lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/lark/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-lark'
  spec.version       = Fastlane::Lark::VERSION
  spec.author        = 'sbahari'
  spec.email         = 'sbahari1090@gmail.com'

  spec.summary       = 'Fastlane plugin to send webhook notification to lark'
  spec.homepage      = "https://github.com/sbahari/fastlane-plugin-lark"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*.rb"] + %w(README.md LICENSE)
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.required_ruby_version = '>= 2.6'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'
end
