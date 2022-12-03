# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rabbitmq_client/version'

Gem::Specification.new do |spec|
  spec.name          = 'rabbitmq_client'
  spec.version       = RabbitmqClient::VERSION
  spec.authors       = ['Al-waleed shihadeh']
  spec.email         = ['wshihadeh dot dev at gmail dot com ']
  spec.summary       = %(RabbitMq client library)
  spec.description   = %(RabbitMq client library support both publish and\b
                         subscribe use cases.)
  spec.homepage      = 'https://github.com/wshihadeh/rabbitmq_client'
  spec.license       = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['homepage_uri'] = spec.homepage

  spec.add_runtime_dependency 'activesupport', '> 5.0.0'
  spec.add_runtime_dependency 'bunny', '>= 2.7.4'
  spec.add_runtime_dependency 'connection_pool', '~> 2.2.2'
  spec.add_runtime_dependency 'sucker_punch', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'byebug', '~> 11.0.1'
  spec.add_development_dependency 'overcommit', '~> 0.52.1'
  spec.add_development_dependency 'rake', '~> 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.9.0'
  spec.add_development_dependency 'rubocop', '~> 0.75.1'
  spec.add_development_dependency 'rubycritic', '~> 4.4.1'
  spec.add_development_dependency 'rubycritic-small-badge', '~> 0.2.1'
  spec.add_development_dependency 'simplecov', '~> 0.18.3'
  spec.add_development_dependency 'simplecov-small-badge', '~> 0.2.4'
  spec.add_development_dependency 'solargraph', '~> 0.38.5'
  spec.add_development_dependency 'timecop', '~> 0.9.1'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`
                       .split("\n").map { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
