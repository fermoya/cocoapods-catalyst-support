# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-catalyst-support/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-catalyst-support'
  spec.version       = CocoapodsCatalystSupport::VERSION
  spec.authors       = ['fermoya']
  spec.email         = ['fmdr.ct@gmail.com']
  spec.description   = %q{Helps you configure your Catalyst dependencies.}
  spec.summary       = %q{Many libraries you may use for iOS won't compile for your macCatalyst App, thus, making porting your App to the Mac world more difficult than initially expected. This is due to those libraries not being compiled for `x86_64`. `cocoapods-catalyst-support` helps you configure which libraries you'll be using for iOS and which for macCatalyst. }
  spec.homepage      = 'https://github.com/fermoya/cocoapods-catalyst-support'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']
  
  spec.add_dependency 'colored2', '~> 3.1'
  spec.add_dependency 'cocoapods', '~> 1.9'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 12.3.3'
end
