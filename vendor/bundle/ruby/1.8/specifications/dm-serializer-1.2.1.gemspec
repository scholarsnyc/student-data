# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-serializer}
  s.version = "1.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Guy van den Berg}]
  s.date = %q{2011-10-24}
  s.description = %q{DataMapper plugin for serializing Resources and Collections}
  s.email = %q{vandenberg.guy [a] gmail [d] com}
  s.extra_rdoc_files = [%q{LICENSE}, %q{README.rdoc}]
  s.files = [%q{LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/datamapper/dm-serializer}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{datamapper}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{DataMapper plugin for serializing Resources and Collections}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<fastercsv>, ["~> 1.5.4"])
      s.add_runtime_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_runtime_dependency(%q<json>, ["~> 1.6.1"])
      s.add_runtime_dependency(%q<json_pure>, ["~> 1.6.1"])
      s.add_development_dependency(%q<dm-validations>, ["~> 1.2.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.2"])
    else
      s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
      s.add_dependency(%q<fastercsv>, ["~> 1.5.4"])
      s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
      s.add_dependency(%q<json>, ["~> 1.6.1"])
      s.add_dependency(%q<json_pure>, ["~> 1.6.1"])
      s.add_dependency(%q<dm-validations>, ["~> 1.2.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<rspec>, ["~> 1.3.2"])
    end
  else
    s.add_dependency(%q<dm-core>, ["~> 1.2.0"])
    s.add_dependency(%q<fastercsv>, ["~> 1.5.4"])
    s.add_dependency(%q<multi_json>, ["~> 1.0.3"])
    s.add_dependency(%q<json>, ["~> 1.6.1"])
    s.add_dependency(%q<json_pure>, ["~> 1.6.1"])
    s.add_dependency(%q<dm-validations>, ["~> 1.2.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<rspec>, ["~> 1.3.2"])
  end
end
