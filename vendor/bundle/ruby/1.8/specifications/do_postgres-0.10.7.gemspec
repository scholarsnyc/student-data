# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{do_postgres}
  s.version = "0.10.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Dirkjan Bussink}]
  s.date = %q{2011-03-29}
  s.description = %q{Implements the DataObjects API for PostgreSQL}
  s.email = %q{d.bussink@gmail.com}
  s.extensions = [%q{ext/do_postgres/extconf.rb}]
  s.extra_rdoc_files = [%q{ChangeLog.markdown}, %q{LICENSE}, %q{README.markdown}]
  s.files = [%q{ChangeLog.markdown}, %q{LICENSE}, %q{README.markdown}, %q{ext/do_postgres/extconf.rb}]
  s.require_paths = [%q{lib}]
  s.rubyforge_project = %q{dorb}
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{DataObjects PostgreSQL Driver}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<data_objects>, ["= 0.10.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.5"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.7"])
    else
      s.add_dependency(%q<data_objects>, ["= 0.10.7"])
      s.add_dependency(%q<rspec>, ["~> 2.5"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<data_objects>, ["= 0.10.7"])
    s.add_dependency(%q<rspec>, ["~> 2.5"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.7"])
  end
end
