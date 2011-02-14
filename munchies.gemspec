# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'munchies/version'

Gem::Specification.new do |s|
  s.name         = "munchies"
  s.version      = Munchies::VERSION
  s.authors      = ["hukl"]
  s.email        = "contact@smyck.org"
  s.homepage     = "http://github.com/hukl/munchies"
  s.summary      = "Prepares log files for munin modules"
  s.description  = "Emits the last 5 minutes of lines of a log file"

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'
end
