require 'spec_helper'

include Feature::Repository

class FeatureToggleTest < Feature::Repository::ActiveRecordRepository
  attr_accessor :name, :active

  def initialize name, active=nil
    self.name = name
    self.active = active
  end

  def save!
    true
  end

  def destroy!
    true
  end

  def self.destroy_all
    all.map {|o| o = nil}
  end

  def self.pluck(attribute_name)
    all.map(&attribute_name.to_sym)
  end

  def self.where(opts)
    all.select { |f| opts.each_pair.all? {|k, v| f.public_send(k.to_sym) == v } }
  end

  def present?
    true
  end

  def self.find_by_name(name)
    all.select {|f| name == f.name}.first
  end

  def self.exists?(opts)
    !find_by_name(opts[:name]).nil?
  end

  def self.create!(params, opts={})
    new(params[:name], params[:active])
  end

  def self.all
    ObjectSpace.each_object(self).to_a
  end
end

describe Feature::Repository::ActiveRecordRepository do
  before(:each) do
    # Mock the model
    @features = FeatureToggleTest
    @repository = ActiveRecordRepository.new(@features)
  end

  after(:each) do
    @features = nil
    @repository = nil
    ObjectSpace.garbage_collect
  end

  it_behaves_like "a dynamic repository" do
    before(:each) do
      # Mock the model
      @features = FeatureToggleTest
      @repository = ActiveRecordRepository.new(@features)
    end

    after(:each) do
      @features = nil
      @repository = nil
      ObjectSpace.garbage_collect
    end
    let(:repo) do
      @repository
    end
  end

  it 'should have no active features after initialization' do
    expect(@repository.active_features).to eq([])
  end

  it 'should have active features' do
    @repository.create_feature(:active, true)

    expect(@repository.active_features).to eq([:active])
  end

  it 'should add an active feature' do
    expect(@features).to receive(:exists?).with(name: 'feature_a').and_return(false)
    expect(@features).to receive(:create!).with({name: 'feature_a', active: true}, without_protection: :true)

    @repository.add_active_feature :feature_a
  end

  it 'should raise an exception when adding not a symbol as active feature' do
    expect do
      @repository.add_active_feature 'feature_a'
    end.to raise_error(ArgumentError, 'feature_a is not a symbol')
  end

  it 'should raise an exception when adding a active feature already added as active' do
    @repository.add_active_feature :feature_a
    expect do
      @repository.add_active_feature :feature_a
    end.to raise_error(ArgumentError, 'feature :feature_a already added')
  end
end
