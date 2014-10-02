class FeatureToggle < ActiveRecord::Base
  attr_accessible :name, :active if ActiveRecord::Base.respond_to? :attr_accessible

  # Feature name should be present and unique
  validates :name, presence: true, uniqueness: true
end
