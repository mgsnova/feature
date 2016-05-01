require 'spec_helper'

include Feature::Repository

describe Feature::Repository::ActiveRecordRepository do
  before(:each) do
    # Mock the model
    @features = double('FeatureToggle')
    @repository = ActiveRecordRepository.new(@features)
  end

  it 'should have no active features after initialization' do
    allow(@features).to receive(:where) { [] }

    expect(@repository.active_features).to eq([])
  end

  it 'should have active features' do
    allow(@features).to receive(:where).with(active: true) { [double(name: 'active')] }

    expect(@repository.active_features).to eq([:active])
  end

  it 'should add an active feature' do
    expect(@features).to receive(:exists?).with(name: 'feature_a').and_return(false)
    expect(@features).to receive(:create!).with(name: 'feature_a', active: true)

    @repository.add_active_feature :feature_a
  end

  it 'should raise an exception when adding not a symbol as active feature' do
    expect do
      @repository.add_active_feature 'feature_a'
    end.to raise_error(ArgumentError, 'feature_a is not a symbol')
  end

  it 'should raise an exception when adding a active feature already added as active' do
    expect(@features).to receive(:create!).with(name: 'feature_a', active: true)
    allow(@features).to receive(:exists?).and_return(false, true)

    @repository.add_active_feature :feature_a
    expect do
      @repository.add_active_feature :feature_a
    end.to raise_error(ArgumentError, 'feature :feature_a already added')
  end
end
