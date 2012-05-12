# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{data_mapper}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Dan Kubb}]
  s.date = %q{2011-10-13}
  s.description = %q{Faster, Better, Simpler.}
  s.email = [%q{dan.kubb@gmail.com}]
  s.extra_rdoc_files = [%q{History.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.files = [%q{History.txt}, %q{Manifest.txt}, %q{README.txt}]
  s.homepage = %q{http://datamapper.org}
  s.rdoc_options = [%q{--main}, %q{README.txt}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{An Object/Relational Mapper for Ruby}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-aggregates>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-constraints>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-migrations>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-transactions>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-serializer>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-timestamps>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-validations>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<dm-types>, ["~> 1.2.0"])
      s.add_development_dependency(%q<hoe>, ["~> 2.12"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-aggregates>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-constraints>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-migrations>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-transactions>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-serializer>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-timestamps>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-validations>, ["~> 1.2.0"])
      s.add_dependency(%q<dm-types>, ["~> 1.2.0"])
      s.add_dependency(%q<hoe>, ["~> 2.12"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-aggregates>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-constraints>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-migrations>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-transactions>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-serializer>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-timestamps>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-validations>, ["~> 1.2.0"])
    s.add_dependency(%q<dm-types>, ["~> 1.2.0"])
    s.add_dependency(%q<hoe>, ["~> 2.12"])
  end
end
