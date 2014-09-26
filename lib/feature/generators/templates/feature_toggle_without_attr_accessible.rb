class FeatureToggle < ActiveRecord::Base
  # Feature name should be present and unique
  validates :name, presence: true, uniqueness: true
end
