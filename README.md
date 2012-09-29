# Feature

Feature is a [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html) library for ruby.

The feature toggle functionality has to be configured by feature repositories. A feature repository simply provides lists of active and inctive features.
With this approach Feature is higly configurable and not bound to a specific kind of configuration.

## CI status

[![Travis-CI Build Status](https://secure.travis-ci.org/mgsnova/feature.png)](https://secure.travis-ci.org/mgsnova/feature)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mgsnova/feature)

## Installation

        gem install feature

## Examples

### Vanilla Ruby

        require 'feature'

        repo = Feature::Repository::SimpleRepository.new
        repo.add_active_feature :be_nice

        Feature.set_repository repo

        Feature.active?(:be_nice)
        # => true

        Feature.with(:be_nice) do
          puts "you can read this"
        end

### Rails

        # File: Gemfile
        gem 'feature' # Or with version specifier, e.g. '~> 0.4.0'

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
