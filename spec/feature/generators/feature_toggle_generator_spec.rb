require 'feature/generators/feature_generator'
require "generator_spec"

describe Feature::Generators::FeatureGenerator, type: :generator do
  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(FeatureToggle)

  before(:all) do
    prepare_destination
    run_generator
  end

  
  describe 'db/migrate/feature_create_feature_toggles.rb' do
    pending
  end

  describe 'app/models/feature_toggle.rb' do
    specify do
      expect(destination_root).to have_structure {
        no_file 'test.rb'
        directory 'app' do
          directory 'models' do
            file 'feature_toggle.rb' do
              contains "class FeatureToggle < ActiveRecord::Base"
              contains "attr_accessible :name, :active if ActiveRecord::Base.respond_to? :attr_accessible"
              contains "validates :name, presence: true, uniqueness: true"
              contains "end"
            end
          end
        end
      }
    end
  end
  describe 'config/initializers/feature.rb' do
    specify do
      expect(destination_root).to have_structure {
        no_file "test.rb"
        directory "config" do
          directory "initializers" do
            file "feature.rb" do 
              contains "# Set repository to ActiveRecord"
              contains "if FeatureToggle.table_exists?"
              contains "repo = Feature::Repository::ActiveRecordRepository.new(FeatureToggle)"
              contains "Feature.set_repository(repo)"
              contains "end"
            end
          end
        end
      }
    end
  end
end
