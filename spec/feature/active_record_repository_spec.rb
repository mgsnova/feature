require 'spec_helper'

include Feature::Repository

describe Feature::Repository::ActiveRecordRepository do
  before(:each) do
    # Mock the model
    @features = double("FeatureToggle")
    @repository = ActiveRecordRepository.new(@features)
  end

  it "should have no active features after initialization" do
    @features.stub(:where) { Hash.new }

    @repository.active_features.should == []
  end

  it "should add an active feature" do
    @features.should_receive(:exists?).with("feature_a").and_return(false)
    @features.should_receive(:new).with(name: "feature_a", active: true).and_return(stub(save: true))

    @repository.add_active_feature :feature_a
  end

  it "should raise an exception when adding not a symbol as active feature" do
    expect {
      @repository.add_active_feature 'feature_a'
    }.to raise_error(ArgumentError, "given feature feature_a is not a symbol")
  end

  it "should raise an exception when adding a active feature already added as active" do
    @features.should_receive(:new).with(name: "feature_a", active: true).and_return(stub(save: true))
    @features.stub(:exists?).and_return(false, true)

    @repository.add_active_feature :feature_a
    expect {
      @repository.add_active_feature :feature_a
    }.to raise_error(ArgumentError, "feature :feature_a already added to list of active features")
  end
end
