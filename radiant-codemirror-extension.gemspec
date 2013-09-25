# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-codemirror-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-codemirror-extension"
  s.version     = RadiantCodemirrorExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantCodemirrorExtension::AUTHORS
  s.email       = RadiantCodemirrorExtension::EMAIL
  s.homepage    = RadiantCodemirrorExtension::URL
  s.summary     = RadiantCodemirrorExtension::SUMMARY
  s.description = RadiantCodemirrorExtension::DESCRIPTION

  s.add_development_dependency "rake", "~> 10.1.0"
  # s.add_dependency "radiant-some-extension", "~> 1.0.0"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
end
