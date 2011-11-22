# Feature

Feature is a [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html) library for ruby.

The feature toggle functionality has to be configured by feature repositories. A feature repository simply provides lists of active and inctive features.
With this approach Feature is higly configurable and not bound to a specific kind of configuration.

## CI status

[![Travis-CI Build Status](https://secure.travis-ci.org/mgsnova/feature.png)](https://secure.travis-ci.org/mgsnova/feature)

## Installation

        gem install feature

## Example usage

        require 'feature'

        repo = Feature::Repository::SimpleRepository.new
        repo.add_active_feature :be_nice

        Feature.set_repository repo

        Feature.active?(:be_nice)
        # => true

        Feature.with(:be_nice) do
          puts "you can read this"
        end
