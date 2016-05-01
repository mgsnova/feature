[![Gem Version](https://badge.fury.io/rb/feature.svg)](https://rubygems.org/gems/feature)
[![Travis-CI Build Status](https://travis-ci.org/mgsnova/feature.svg)](https://travis-ci.org/mgsnova/feature)
[![Coverage Status](http://img.shields.io/coveralls/mgsnova/feature/master.svg)](https://coveralls.io/r/mgsnova/feature)
[![Code Climate](https://codeclimate.com/github/mgsnova/feature.svg)](https://codeclimate.com/github/mgsnova/feature)
[![Inline docs](http://inch-ci.org/github/mgsnova/feature.svg)](http://inch-ci.org/github/mgsnova/feature)
[![Dependency Status](https://gemnasium.com/mgsnova/feature.svg)](https://gemnasium.com/mgsnova/feature)

# Feature

Feature is a battle-tested [feature toggle](http://martinfowler.com/bliki/FeatureToggle.html) library for ruby.

The feature toggle functionality has to be configured by feature repositories. A feature repository simply provides lists of active features (symbols!). Unknown features are assumed inactive.

With this approach Feature is highly configurable and not bound to a specific kind of configuration.

**NOTE:** The current gem version works with Ruby 2+ and supports Ruby on Rails 4+.

**NOTE:** Ruby 1.9 is supported until version 1.2.0, Ruby 1.8 is supported until version 0.7.0.

**NOTE:** ActiveRecord / Rails 3 is supported until version 1.1.0.

## Installation

        gem install feature

## How to use

* Setup Feature
    * Create a repository (for more infos about configuration backends, see section below)
        ```ruby
        require 'feature'
        repo = Feature::Repository::SimpleRepository.new
        ```

    * Set repository to Feature
        ```ruby
        Feature.set_repository(repo)
        ```

* Use Feature in your production code
    ```ruby
    Feature.active?(:feature_name) # => true/false

    Feature.inactive?(:feature_name) # => true/false

    Feature.active_features # => [:list, :of, :features]

    Feature.with(:feature_name) do
      # code
    end

    Feature.without(:feature_name) do
      # code
    end

    # this returns value_true if :feature_name is active, otherwise value_false
    Feature.switch(:feature_name, value_true, value_false)

    # switch may also take Procs that will be evaluated and it's result returned.
    Feature.switch(:feature_name, -> { code... }, -> { code... })
    ```

* Use Feature in your test code (for reliable testing of feature depending code)
    ```ruby
    require 'feature/testing'

    Feature.run_with_activated(:feature) do
      # your test code
    end

    # you also can give a list of features
    Feature.run_with_deactivated(:feature, :another_feature) do
      # your test code
    end
    ```

* Feature-toggle caching

    * By default, Feature will lazy-load the active features from the
      underlying repository the first time you try to check whether a
      feature is set or not.

    * Subsequent calls to Feature will access the cached in-memory
      representation of the list of features. So changes to toggles in the
      underlying repository would not be reflected in the application

      until you restart the application or manally call
        ```ruby
        Feature.refresh!
        ```

    * You can optionally pass in true as a second argument on
      set_repository, to force Feature to auto-refresh the feature list
      on every feature-toggle check you make.

        ```ruby
        Feature.set_repository(your_repository, true)
        ```

## How to read current features

    * get the value of a feature

        ```ruby
        Feature.get(:feature_name) # => true or false depending on if it is active or not
        ```

    * list the names of all defined features

        ```ruby
        Feature.list # => list of all feature names
        ```

## How to add/update/remove current features
Note: Only works for dynamic repositories (aka, excludes YamlRepository)

    * set the value of a feature to active

        ```ruby
        Feature.set(:my_feature, true) # returns true if successful
        ```

    * set the value of a feature to inactive

        ```ruby
        Feature.set(:my_feature, false) # returns true if successful
        ```

    * add an active feature

        ```ruby
        Feature.add(:my_feature, true) # returns true if successful
        # Or
        Feature.create(:my_feature, true) # returns true if successful
        ```

    * add an inactive feature

        ```ruby
        Feature.add(:my_feature, false) # returns true if successful
        # Or
        Feature.create(:my_feature, false) # returns true if successful
        ```

    * remove a feature

        ```ruby
        Feature.remove(:my_feature) # returns true if successful
        # Or
        Feature.destroy(:my_feature) # returns true if successful
        ```


## How to setup different backends

### SimpleRepository (in-memory)
```ruby
# File: Gemfile
gem 'feature'
```

```ruby
# setup code
require 'feature'

repo = Feature::Repository::SimpleRepository.new
repo.create :be_nice

Feature.set_repository repo
```

### RedisRepository (features configured in redis server)
```ruby
# See here to learn how to configure redis: https://github.com/redis/redis-rb

# File: Gemfile
gem 'feature'
gem 'redis'
```

```ruby
# setup code (or Rails initializer: config/initializers/feature.rb)
require 'feature'

# "feature_toggles" will be the key name in redis
repo = Feature::Repository::RedisRepository.new("feature_toggles")
Feature.set_repository repo

# add/toggle features in Redis
Redis.current.hset("feature_toggles", "ActiveFeature", true)
Redis.current.hset("feature_toggles", "InActiveFeature", false)
```

### YamlRepository (features configured in static yml file)
```ruby
# File: Gemfile
gem 'feature'
```

```
# File: config/feature.yml
features:
    an_active_feature: true
    an_inactive_feature: false
```

```ruby
# setup code (or Rails initializer: config/initializers/feature.rb)
repo = Feature::Repository::YamlRepository.new("#{Rails.root}/config/feature.yml")
Feature.set_repository repo
```

You may also specify a Rails environment to use a new feature in development and test, but not production:
```
# File: config/feature.yml
test:
    features:
        a_new_feature: true
production:
    features:
        a_new_feature: false
```

```ruby
# File: config/initializers/feature.rb
repo = Feature::Repository::YamlRepository.new("#{Rails.root}/config/feature.yml", Rails.env)
Feature.set_repository repo
```

### ActiveRecordRepository (features configured in a database) using Rails

```ruby
# File: Gemfile
gem 'feature'
```

```
# Run generator and migrations
$ rails g feature:install
$ rake db:migrate
```

```ruby
# Add Features to table FeaturesToggle for example in
# File: db/schema.rb
FeatureToggle.create!(name: "ActiveFeature", active: true)
FeatureToggle.create!(name: "InActiveFeature", active: false)

# or in initializer
# File: config/initializers/feature.rb
repo.create(:active_feature, true)
```
