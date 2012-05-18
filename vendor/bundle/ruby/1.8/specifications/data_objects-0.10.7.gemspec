# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{data_objects}
  s.version = "0.10.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Dirkjan Bussink}]
  s.date = %q{2011-03-29}
  s.description = %q{Provide a standard and simplified API for communicating with RDBMS from Ruby}
  s.email = %q{d.bussink@gmail.com}
  s.extra_rdoc_files = [%q{README.markdown}]
  s.files = [%q{README.markdown}]
  s.homepage = %q{http://github.com/datamapper/do}
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{dorb}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{DataObjects basic API and shared driver specifications}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>, ["~> 2.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<yard>, ["~> 0.5"])
    else
      s.add_dependency(%q<addressable>, ["~> 2.1"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<yard>, ["~> 0.5"])
    end
  else
    s.add_dependency(%q<addressable>, ["~> 2.1"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<yard>, ["~> 0.5"])
  end
end
