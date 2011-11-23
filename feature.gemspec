require 'rake/gempackagetask'

Gem::Specification.new do |s|
  s.name = "feature"
  s.version = "0.3.0"

  s.authors = ["Markus Gerdes"]
  s.email = %q{github@mgsnova.de}

  s.homepage = %q{http://github.com/mgsnova/feature}
  s.require_paths = ["lib"]
  s.summary = "Feature Toggle library for ruby"
  s.files = FileList["{lib,spec}/**/*"].exclude("rdoc").to_a + ["Rakefile", "Gemfile", "README.md", "CHANGELOG.md"]
end
