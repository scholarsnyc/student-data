# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-aggregates}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Foy Savas}]
  s.date = %q{2011-10-09}
  s.description = %q{DataMapper plugin providing support for aggregates on collections}
  s.email = %q{foysavas [a] gmail [d] com}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/datamapper/dm-aggregates}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{DataMapper plugin providing support for aggregates on collections}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.2"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3.2"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3.2"])
  end
end
