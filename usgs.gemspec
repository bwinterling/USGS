# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'usgs/version'

Gem::Specification.new do |spec|
  spec.name          = "usgs"
  spec.version       = Usgs::VERSION
  spec.authors       = ["Brian Winterling"]
  spec.email         = ["bwinterling@yahoo.com"]
  spec.description   = %q{Access the USGS Water Services API for streamflow data.}
  spec.summary       = %q{Single query access to USGS Streamflow data returning Gauge objects.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
