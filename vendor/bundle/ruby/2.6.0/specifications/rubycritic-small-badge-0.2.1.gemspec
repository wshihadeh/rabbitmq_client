# -*- encoding: utf-8 -*-
# stub: rubycritic-small-badge 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rubycritic-small-badge".freeze
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marc Grimme".freeze]
  s.date = "2019-08-30"
  s.email = ["marc.grimme at gmail dot com".freeze]
  s.executables = ["console".freeze]
  s.files = ["bin/console".freeze]
  s.homepage = "https://github.com/marcgrimme/rubycritic-small-badge".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Small Badge generator for RubyCritic analysis tool for ruby".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<repo-small-badge>.freeze, ["~> 0.2.7"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.65"])
      s.add_development_dependency(%q<rubycritic>.freeze, ["~> 4.1"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.17"])
      s.add_development_dependency(%q<simplecov-small-badge>.freeze, ["~> 0.2.3"])
    else
      s.add_dependency(%q<repo-small-badge>.freeze, ["~> 0.2.7"])
      s.add_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.8"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.65"])
      s.add_dependency(%q<rubycritic>.freeze, ["~> 4.1"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.17"])
      s.add_dependency(%q<simplecov-small-badge>.freeze, ["~> 0.2.3"])
    end
  else
    s.add_dependency(%q<repo-small-badge>.freeze, ["~> 0.2.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.8"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.65"])
    s.add_dependency(%q<rubycritic>.freeze, ["~> 4.1"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.17"])
    s.add_dependency(%q<simplecov-small-badge>.freeze, ["~> 0.2.3"])
  end
end
