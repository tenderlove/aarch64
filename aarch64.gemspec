$: << File.expand_path("lib")

require "aarch64/version"

Gem::Specification.new do |s|
  s.name        = "aarch64"
  s.version     = AArch64::VERSION
  s.summary     = "Write ARM64 assembly in Ruby!"
  s.description = "Tired of writing Ruby in Ruby? Now you can write ARM64 assembly in Ruby!"
  s.authors     = ["Aaron Patterson"]
  s.email       = "tenderlove@ruby-lang.org"
  s.files       = `git ls-files -z`.split("\x0")
  s.test_files  = s.files.grep(%r{^test/})
  s.homepage    = "https://github.com/tenderlove/aarch64"
  s.license     = "Apache-2.0"

  s.add_runtime_dependency 'racc', '~> 1.6'
  s.add_development_dependency 'hatstone', '~> 1.0.0'
  s.add_development_dependency 'jit_buffer', '~> 1.0.0'
  s.add_development_dependency 'minitest', '~> 5.15'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'odinflex', '~> 1.0'
end
