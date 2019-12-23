# -*- encoding: utf-8 -*-
# stub: sucker_punch 2.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "sucker_punch".freeze
  s.version = "2.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/brandonhilkert/sucker_punch/issues", "changelog_uri" => "https://github.com/brandonhilkert/sucker_punch/blob/master/CHANGES.md", "source_code_uri" => "https://github.com/brandonhilkert/sucker_punch" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brandon Hilkert".freeze]
  s.date = "2019-05-16"
  s.description = "Asynchronous processing library for Ruby".freeze
  s.email = ["brandonhilkert@gmail.com".freeze]
  s.homepage = "https://github.com/brandonhilkert/sucker_punch".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "Sucker Punch v2.0 introduces backwards-incompatible changes.\nPlease see https://github.com/brandonhilkert/sucker_punch/blob/master/CHANGES.md#200 for details.".freeze
  s.rubygems_version = "3.0.6".freeze
  s.summary = "Sucker Punch is a Ruby asynchronous processing using concurrent-ruby, heavily influenced by Sidekiq and girl_friday.".freeze

  s.installed_by_version = "3.0.6" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
      s.add_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
  end
end
