require 'rake/testtask'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rspec_opts = ['--colour', '-f documentation', '--backtrace']
end

task :mutant do
  require 'mutant'
  result = Mutant::CLI.run(%w(--include lib --require feature --use rspec Feature*))
  raise unless result == Mutant::CLI::EXIT_SUCCESS
end

task default: [:spec, :rubocop]
