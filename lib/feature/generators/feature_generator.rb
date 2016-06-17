
# Is this ok?
if defined?(Rails) && Rails::VERSION::STRING > '3'
  require 'rails/generators'
  require 'rails/generators/active_record'

  module Feature
    # Rails generator for generating feature ActiveRecord model
    # and migration step for creating the table
    module Generators
      class FeatureGenerator < ActiveRecord::Generators::Base
        desc 'This generator creates a migration and a model for FeatureToggles.'

        source_root File.expand_path("../templates", __FILE__)
        namespace :feature

        def generate_model
          invoke "active_record:model", [ name ], :migration => false
        end

        def generate_initializer
          template 'feature.rb', 'config/initializers/feature.rb'
        end

        def inject_feature_model_content
          if self.behavior == :invoke
            inject_into_class(model_path, class_name, model_content)
          end
        end

        def copy_feature_migration
          migration_template "migration.rb", "db/migrate/feature_create_#{table_name}.rb"
        end

        private

        def model_path
          File.join("app", "models", "#{file_path}.rb")
        end

        def model_content
          File.read(File.join(__dir__, 'templates/model.rb'))
        end
      end
    end
  end
end
