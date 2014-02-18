require 'rails/generators'

module Feature
  class InstallGenerator < Rails::Generators::Base
    desc 'This generator creates a migration and a model for FeatureToggles.'
    source_root File.expand_path('../templates', __FILE__)

    def generate_model
      generate :model, 'feature_toggle name:string active:boolean'
      inject_into_class 'app/models/feature_toggle.rb', 'FeatureToggle' do
        "  # Feature name should be present and unique\n"\
        "  validates :name, presence: true, uniqueness: true\n"
      end
    end

    def generate_initializer
      template 'feature.rb', 'config/initializers/feature.rb'
    end
  end
end
