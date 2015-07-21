source 'https://rubygems.org'


gem "rake"

group :test do
  gem 'coveralls', require: false
  gem 'rubocop', require: false
  gem "rspec"
  gem "rspec-mocks"
  gem "fakeredis"
  if RUBY_VERSION >= '2.1'
    gem 'mutant'
    gem 'mutant-rspec'
  end
end
