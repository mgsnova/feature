  attr_accessible :name, :active if ActiveRecord::Base.respond_to? :attr_accessible
  validates :name, presence: true, uniqueness: true
