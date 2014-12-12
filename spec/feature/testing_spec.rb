require 'spec_helper'
require 'feature/testing'

describe 'Feature testing support' do
  before(:all) do
    repository = Feature::Repository::SimpleRepository.new
    repository.add_active_feature(:active_feature)
    Feature.set_repository(repository)
  end

  before do
    expect(Feature.active?(:active_feature)).to be_truthy
    expect(Feature.active?(:deactive_feature)).to be_falsey
  end

  after do
    expect(Feature.active?(:active_feature)).to be_truthy
    expect(Feature.active?(:deactive_feature)).to be_falsey
  end

  describe '.run_with_activated' do
    it 'activates a deactivated feature' do
      Feature.run_with_activated(:deactive_feature) do
        expect(Feature.active?(:deactive_feature)).to be_truthy
      end
    end
  end

  describe '.run_with_deactivated' do
    it 'deactivates an activated feature' do
      Feature.run_with_deactivated(:active_feature) do
        expect(Feature.active?(:active_feature)).to be_falsey
      end
    end
  end
end
