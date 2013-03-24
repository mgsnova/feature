require 'spec_helper'
require 'feature/testing'

describe "Feature testing support" do
  before(:each) do
    repository = SimpleRepository.new
    repository.add_active_feature(:active_feature)
    Feature.set_repository(repository)
  end

  it "should execute code block with an deactivated feature" do
    Feature.active?(:another_feature).should be_false

    Feature.run_with_activated(:another_feature) do
      Feature.active?(:another_feature).should be_true
    end

    Feature.active?(:another_feature).should be_false
  end

  it "should execute code block with an deactivated feature" do
    Feature.active?(:active_feature).should be_true

    Feature.run_with_deactivated(:active_feature) do
      Feature.active?(:active_feature).should be_false
    end

    Feature.active?(:active_feature).should be_true
  end
end
