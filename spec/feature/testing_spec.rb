require 'spec_helper'
require 'feature/testing'

describe "Feature testing support" do
  before(:each) do
    repository = SimpleRepository.new
    repository.add_active_feature(:active_feature)
    Feature.set_repository(repository)
  end

  it "should execute code block with an deactivated feature" do
    expect(Feature.active?(:another_feature)).to be_falsey

    Feature.run_with_activated(:another_feature) do
      expect(Feature.active?(:another_feature)).to be_truthy
    end

    expect(Feature.active?(:another_feature)).to be_falsey
  end

  it "should execute code block with an deactivated feature" do
    expect(Feature.active?(:active_feature)).to be_truthy

    Feature.run_with_deactivated(:active_feature) do
      expect(Feature.active?(:active_feature)).to be_falsey
    end

    expect(Feature.active?(:active_feature)).to be_truthy
  end
end
