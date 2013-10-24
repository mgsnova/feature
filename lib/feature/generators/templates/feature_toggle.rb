class FeatureToggle < ActiveRecord::Base
  attr_accessible :name, :active

  # Feature name should be present and unique
  validates :name, :presence => true, :uniqueness => true
end
