# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'worse_model/version'

Gem::Specification.new do |spec|
  spec.name          = 'worse_model'
  spec.version       = WorseModel::VERSION
  spec.authors       = ['mdouchement']
  spec.email         = ['marc.douchement@predicsis.com']

  spec.summary       = %q{In memory DB using ActiveModel.}
  spec.description   = %q{In memory DB using ActiveModel.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activemodel', '>= 4.0.0'
  spec.add_dependency 'rails-observers'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
end
