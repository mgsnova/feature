require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s|
  s.name = "feature"
  s.version = "0.1.0"

  s.authors = ["Markus Gerdes"]
  s.email = %q{github@mgsnova.de}

  s.homepage = %q{http://github.com/mgsnova/feature}
  s.require_paths = ["lib"]
  s.summary = "Feature Toggle library for ruby"
  s.files = FileList["{lib,spec}/**/*"].exclude("rdoc").to_a + ["Rakefile", "Gemfile"]
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
end

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--colour', '-f documentation', '--backtrace']
end

task :default => [:spec] do
end
