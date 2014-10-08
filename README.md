[![Gem Version](https://badge.fury.io/rb/feature.svg)](https://rubygems.org/gems/feature)
[![Travis-CI Build Status](https://travis-ci.org/mgsnova/feature.svg)](https://travis-ci.org/mgsnova/feature)
[![Code Climate](https://codeclimate.com/github/mgsnova/feature.svg)](https://codeclimate.com/github/mgsnova/feature)
[![Coverage Status](http://img.shields.io/coveralls/mgsnova/feature/master.svg)](https://coveralls.io/r/mgsnova/feature)

# Feature

Feature is a battle-tested [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html) library for ruby.

The feature toggle functionality has to be configured by feature repositories. A feature repository simply provides lists of active features (symbols!). Unknown features are assumed inactive.
With this approach Feature is higly configurable and not bound to a specific kind of configuration.

**NOTE:** Ruby 1.8 is only supported until version 0.7.0. Later Versions require at least Ruby 1.9.

**NOTE:** Using feature with ActiveRecord and Rails 3 MAY work. Use version 1.1.0 if you need support for Rails 3.

## Installation

        gem install feature

## How to use

* Setup Feature
    * Create a repository (see examples below)
    * set repository to Feature

            Feature.set_repository(your_repository)

* Use Feature in your production code

        Feature.active?(:feature_name) # => true/false

        Feature.inactive?(:feature_name) # => true/false

        Feature.with(:feature_name) do
          # code
        end

        Feature.without(:feature_name) do
          # code
        end

        Feature.switch(:feature_name, value_true, value_false) # => returns value_true if :feature_name is active, otherwise value_false

        # May also take Procs (here in Ruby 1.9 lambda syntax), returns code evaluation result.
        Feature.switch(:feature_name, -> { code... }, -> { code... })

* Use Feature in your test code (for reliable testing of feature depending code)

        require 'feature/testing'

        Feature.run_with_activated(:feature_name) do
          # your test code
        end

        Feature.run_with_deactivated(:feature_name) do
          # your test code
        end

## Examples

### Vanilla Ruby using SimpleRepository

        # setup code
        require 'feature'

        repo = Feature::Repository::SimpleRepository.new
        repo.add_active_feature :be_nice

        Feature.set_repository repo

        # production code
        Feature.active?(:be_nice)
        # => true

        Feature.with(:be_nice) do
          puts "you can read this"
        end

### Rails using YamlRepository

        # File: Gemfile
        gem 'feature'

        # File: config/feature.yml
        features:
            an_active_feature: true
            an_inactive_feature: false

        # File: config/initializers/feature.rb
        repo = Feature::Repository::YamlRepository.new("#{Rails.root}/config/feature.yml")
        Feature.set_repository repo

        # File: app/views/example/index.html.erb
        <% if Feature.active?(:an_active_feature) %>
          <%# Feature implementation goes here %>
        <% end %>

You may also specify a Rails environment to use a new feature in development and test, but not production:

        # File: config/feature.yml
        development:
            features:
                a_new_feature: true
        test:
            features:
                a_new_feature: true
        production:
            features:
                a_new_feature: false

        # File: config/initializers/feature.rb
        repo = Feature::Repository::YamlRepository.new("#{Rails.root}/config/feature.yml", Rails.env)
        Feature.set_repository repo

### Rails using ActiveRecordRepository

        # File: Gemfile
        gem 'feature'

        # Run generator and migrations
        $ rails g feature:install
        $ rake db:migrate

        # Add Features to table FeaturesToggle for example in
        # File: db/schema.rb
        FeatureToggle.create!(name: "ActiveFeature", active: true)
        FeatureToggle.create!(name: "InActiveFeature", active: false)

        # or in initializer
        # File: config/initializers/feature.rb
        repo.add_active_feature(:active_feature)

        # File: app/views/example/index.html.erb
        <% if Feature.active?(:an_active_feature) %>
          <%# Feature implementation goes here %>
        <% end %>
