# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rack-protection}
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Konstantin Haase}, %q{Corey Ward}, %q{David Kellum}, %q{Fojas}]
  s.date = %q{2011-10-04}
  s.description = %q{You should use protection!}
  s.email = [%q{konstantin.mailinglists@googlemail.com}, %q{coreyward@me.com}, %q{dek-oss@gravitext.com}, %q{developer@fojasaur.us}]
  s.homepage = %q{http://github.com/rkh/rack-protection}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{You should use protection!}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<rack-test>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
  end
end
