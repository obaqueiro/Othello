# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "Othello"
  spec.version       = '1.0'
  spec.authors       = ["Charles Lambert"]
  spec.email         = ["c.lambert1213@gmail.com"]
  # spec.summary       = %q{Short summary of your project}
  # spec.description   = %q{Longer description of your project.}
  # spec.homepage      = "http://domainforproject.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/Othello.rb']
  # spec.executables   = ['bin/NAME']
  spec.test_files    = ['tests/*.rb']
  spec.require_paths = ["lib"]
end
