# frozen_string_literal: true

# Copyright (c) 2018-2020 Robert Haines.
#
# Licensed under the BSD License. See LICENCE for details.

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ffi/openmpt/version'

Gem::Specification.new do |spec|
  spec.name          = 'ffi-openmpt'
  spec.version       = FFI::OpenMPT::VERSION
  spec.authors       = ['Robert Haines']
  spec.email         = ['robert.haines@manchester.ac.uk']

  spec.summary       = 'A Ruby library to interface with libopenmpt.'
  spec.description   = 'libopenmpt is a library to render tracker music ' \
    '(MOD, XM, S3M, IT, MPTM and dozens of other legacy formats) to a ' \
    'PCM audio stream. See https://openmpt.org/ for more information.'
  spec.homepage      = 'https://github.com/hainesr/ffi-openmpt'
  spec.license       = 'BSD'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_runtime_dependency 'ffi', '~> 1.9'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'coveralls', '~> 0.8'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 12.3.3'
  spec.add_development_dependency 'rubocop', '0.77.0'
  spec.add_development_dependency 'rubocop-performance', '1.5.0'
end
