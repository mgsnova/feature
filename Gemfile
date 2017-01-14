source 'https://rubygems.org'

gem 'rake'

group :test do
  gem 'coveralls', require: false
  gem 'fakeredis'
  gem 'rspec'
  gem 'rspec-mocks'
  gem 'rubocop', require: false
  gem 'timecop'
  if RUBY_VERSION >= '2.1'
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
