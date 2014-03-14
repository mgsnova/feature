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
      template 'feature_toggle.rb', 'app/models/feature_toggle.rb'
      migration_template 'create_feature_toggles.rb', 'db/migrate/create_feature_toggles.rb'
    end
  end
end
