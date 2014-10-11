# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'ruby-typescript'

Gem::Specification.new do |s|
  s.name        = 'ruby-typescript'
  s.version     = TypeScript::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Payton Yao']
  s.email       = ['payton.yao@gmail.com']
  s.homepage    = 'http://github.com/jabbawookiees/ruby-typescript'
  s.summary     = 'Ruby TypeScript Compiler'
  s.description = 'Ruby TypeScript is a wrapper for the JavaScript TypeScript compiler.'
  s.license = 'MIT'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project = 'ruby-typescript'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'

  s.files        = Dir.glob('{lib}/**/*') + %w[LICENSE README.md]
  s.require_path = 'lib'
end
