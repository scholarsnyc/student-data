# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stringex}
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Russell Norris}]
  s.date = %q{2011-08-08}
  s.description = %q{Some [hopefully] useful extensions to Ruby's String class. Stringex is made up of three libraries: ActsAsUrl [permalink solution with better character translation], Unidecoder [Unicode to Ascii transliteration], and StringExtensions [miscellaneous helper methods for the String class].}
  s.email = %q{rsl@luckysneaks.com}
  s.extra_rdoc_files = [%q{MIT-LICENSE}, %q{README.rdoc}]
  s.files = [%q{MIT-LICENSE}, %q{README.rdoc}]
  s.homepage = %q{http://github.com/rsl/stringex}
  s.rdoc_options = [%q{--main}, %q{README.rdoc}, %q{--charset}, %q{utf-8}, %q{--line-numbers}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Some [hopefully] useful extensions to Ruby's String class}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
