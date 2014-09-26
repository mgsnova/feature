require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Feature
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    extend Rails::Generators::Migration

    desc 'This generator creates a migration and a model for FeatureToggles.'
    source_root File.expand_path('../templates', __FILE__)

    def create_model_file
      template 'feature.rb', 'config/initializers/feature.rb'
      template appropriate_feature_toggle_rb, 'app/models/feature_toggle.rb'
      migration_template 'create_feature_toggles.rb', 'db/migrate/create_feature_toggles.rb'
    end

    def self.next_migration_number(path)
      ActiveRecord::Generators::Base.next_migration_number(path)
    end

    private

    def appropriate_feature_toggle_rb
      # For Rails 4 + protected_attributes or Rails 3, we prefer the model with `attr_accessible` pre-populated
      if ActiveRecord::Base.respond_to? :attr_accessible
        'feature_toggle.rb'
      else
        'feature_toggle_without_attr_accessible.rb'
      end
    end
  end
end
