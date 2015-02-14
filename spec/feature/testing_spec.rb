require 'spec_helper'
require 'feature/testing'

shared_examples 'a testable repository' do
  before do
    expect(Feature.active?(:active_feature)).to be_truthy
    expect(Feature.active?(:another_active_feature)).to be_truthy
    expect(Feature.active?(:deactive_feature)).to be_falsey
    expect(Feature.active?(:another_deactive_feature)).to be_falsey
  end

  after do
    expect(Feature.active?(:active_feature)).to be_truthy
    expect(Feature.active?(:another_active_feature)).to be_truthy
    expect(Feature.active?(:deactive_feature)).to be_falsey
    expect(Feature.active?(:another_deactive_feature)).to be_falsey
  end

  describe '.run_with_activated' do
    it 'activates a deactivated feature' do
      Feature.run_with_activated(:deactive_feature) do
        expect(Feature.active?(:deactive_feature)).to be_truthy
      end
    end

    it 'activates multiple deactivated features' do
      Feature.run_with_activated(:deactive_feature, :another_deactive_feature) do
        expect(Feature.active?(:deactive_feature)).to be_truthy
        expect(Feature.active?(:another_deactive_feature)).to be_truthy
      end
    end
  end

  describe '.run_with_deactivated' do
    it 'deactivates an activated feature' do
      Feature.run_with_deactivated(:active_feature) do
        expect(Feature.active?(:active_feature)).to be_falsey
      end
    end

    it 'deactivates multiple activated features' do
      Feature.run_with_deactivated(:active_feature, :another_active_feature) do
        expect(Feature.active?(:active_feature)).to be_falsey
        expect(Feature.active?(:another_active_feature)).to be_falsey
      end
    end
  end
end

describe 'Feature testing support' do
  context 'without auto_refresh' do
    before(:all) do
      repository = Feature::Repository::SimpleRepository.new
      repository.add_active_feature(:active_feature)
      repository.add_active_feature(:another_active_feature)
      Feature.set_repository(repository)
    end

    it_behaves_like 'a testable repository'
  end

  context 'with auto_refresh' do
    before(:all) do
      repository = Feature::Repository::SimpleRepository.new
      repository.add_active_feature(:active_feature)
      repository.add_active_feature(:another_active_feature)
      Feature.set_repository(repository, true)
    end

    it_behaves_like 'a testable repository'

    describe '.run_with_deactivated' do
      it 'should disable perform_initial_refresh for the first call to Feature.active?' do
        Feature.run_with_activated(:deactive_feature) do
          expect(Feature.active?(:deactive_feature)).to be_truthy
        end
      end
    end

    describe '.run_with_deactivated' do
      it 'should disable perform_initial_refresh for the first call to Feature.active?' do
        Feature.run_with_deactivated(:active_feature) do
          expect(Feature.active?(:active_feature)).to be_falsey
        end
      end
    end
  end

  context 'with no features activated' do
    before(:all) do
      repository = Feature::Repository::SimpleRepository.new
      Feature.set_repository(repository)
    end

    describe '.run_with_activated' do
      it 'should not raise an error' do
        expect { Feature.run_with_activated(:foo) {} }.to_not raise_error
      end
    end

    describe '.run_with_deactivated' do
      it 'should not raise an error' do
        expect { Feature.run_with_deactivated(:foo) {} }.to_not raise_error
      end
    end
  end
end
