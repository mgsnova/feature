# Feature

Feature is a battle-tested [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html) library for ruby.

The feature toggle functionality has to be configured by feature repositories. A feature repository simply provides lists of active features (symbols!). Unknown features are assumed deactive.
With this approach Feature is higly configurable and not bound to a specific kind of configuration.

## CI status

[![Gem Version](https://badge.fury.io/rb/feature.png)](https://rubygems.org/gems/feature)
[![Travis-CI Build Status](https://travis-ci.org/mgsnova/feature.png)](https://travis-ci.org/mgsnova/feature)
[![Code Climate](https://codeclimate.com/github/mgsnova/feature.png)](https://codeclimate.com/github/mgsnova/feature)
[![Coverage Status](https://coveralls.io/repos/mgsnova/feature/badge.png)](https://coveralls.io/r/mgsnova/feature)

## Installation

        gem install feature

## How to use

* Setup Feature
    * Create a repository (see examples below)
    * set repository to Feature

        Feature.set_repository(your_repository)

* Use Feature in your production code

        Feature.active(:feature_name) # => true/false

        Feature.deactive?(:feature_name) # => true/false

        Feature.with(:feature_name) do
          # code
        end

        Feature.without(:feature_name) do
          # code
        end

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
        gem 'feature' # Or with version specifier, e.g. '~> 0.6.0'

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
