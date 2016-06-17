source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'coveralls', require: false
  gem 'rubocop', require: false
  gem 'timecop'
  gem 'fakeredis'
  gem "generator_spec"
  if RUBY_VERSION >= '2.1'
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
