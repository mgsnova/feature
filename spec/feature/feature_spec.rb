require 'spec_helper'

describe Feature do
  context 'without FeatureRepository' do
    it 'should raise an exception when calling active?' do
      expect do
        Feature.active?(:feature_a)
      end.to raise_error('missing Repository for obtaining feature lists')
    end

    it 'should raise an exception when calling inactive?' do
      expect do
        Feature.inactive?(:feature_a)
      end.to raise_error('missing Repository for obtaining feature lists')
    end

    it 'should raise an exception when calling with' do
      expect do
        Feature.with(:feature_a) do
        end
      end.to raise_error('missing Repository for obtaining feature lists')
    end

    it 'should raise an exception when calling without' do
      expect do
        Feature.without(:feature_a) do
        end
      end.to raise_error('missing Repository for obtaining feature lists')
    end

    it 'should raise an exception when calling active_features' do
      expect do
        Feature.active_features
      end.to raise_error('missing Repository for obtaining feature lists')
    end
  end

  context 'setting Repository' do
    before(:each) do
      @repository = Feature::Repository::SimpleRepository.new
    end

    context 'with auto_refresh set to false' do
      before(:each) do
        Feature.set_repository @repository
      end
      it 'should raise an exception when add repository with wrong class' do
        expect do
          Feature.set_repository('not a repository')
        end.to raise_error(ArgumentError, 'given repository does not respond to active_features')
      end

      it 'should get active features lazy on first usage' do
        @repository.create(:feature_a, true)
        # the line below will be the first usage of feature in this case
        expect(Feature.active?(:feature_a)).to be_truthy
      end

      it 'should get active features from repository once' do
        Feature.active?(:does_not_matter)
        @repository.create(:feature_a, true)
        expect(Feature.active?(:feature_a)).to be_falsey
      end

      it 'should reload active features on first call only' do
        @repository.create(:feature_a, true)
        expect(@repository).to receive(:active_features).once.and_return(@repository.active_features)
        Feature.active?(:feature_a)
        Feature.active?(:feature_a)
      end
    end

    context 'with auto_refresh set to true' do
      before(:each) do
        Feature.set_repository @repository, true
      end
      it 'should reload active features on every call' do
        @repository.create(:feature_a, true)
        expect(@repository).to receive(:active_features).twice.and_return(@repository.active_features)
        Feature.active?(:feature_a)
        Feature.active?(:feature_a)
      end
    end
  end

  context 'refresh features' do
    before(:each) do
      @repository = Feature::Repository::SimpleRepository.new
      Feature.set_repository @repository
    end

    it 'should refresh active feature lists from repository' do
      @repository.create(:feature_a, true)
      Feature.refresh!
      expect(Feature.active?(:feature_a)).to be_truthy
    end
  end

  context 'request features' do
    before(:each) do
      @repository = Feature::Repository::SimpleRepository.new
      @repository.create(:feature_active, true)
      @repository.create(:feature_inactive, false)
      Feature.set_repository @repository
    end

    it 'should affirm active feature is active' do
      expect(Feature.active?(:feature_active)).to be_truthy
    end

    it 'should not affirm active feature is inactive' do
      expect(Feature.inactive?(:feature_active)).to be_falsey
    end

    it 'should affirm inactive feature is inactive' do
      expect(Feature.inactive?(:feature_inactive)).to be_truthy
    end

    it 'should not affirm inactive feature is active' do
      expect(Feature.active?(:feature_inactive)).to be_falsey
    end

    it 'should call block with active feature in active list' do
      reached = false

      Feature.with(:feature_active) do
        reached = true
      end

      expect(reached).to be_truthy
    end

    it 'should not call block with active feature not in active list' do
      reached = false

      Feature.with(:feature_inactive) do
        reached = true
      end

      expect(reached).to be_falsey
    end

    it 'should raise exception when no block given to with' do
      expect do
        Feature.with(:feature_active)
      end.to raise_error(ArgumentError, 'no block given to with')
    end

    it 'should call block without inactive feature in inactive list' do
      reached = false

      Feature.without(:feature_inactive) do
        reached = true
      end

      expect(reached).to be_truthy
    end

    it 'should not call block without inactive feature in inactive list' do
      reached = false

      Feature.without(:feature_active) do
        reached = true
      end

      expect(reached).to be_falsey
    end

    it 'should raise exception when no block given to without' do
      expect do
        Feature.without(:feature_inactive)
      end.to raise_error(ArgumentError, 'no block given to without')
    end

    describe '#switch' do
      context 'given a value' do
        it 'should return the first value if the feature is active' do
          retval = Feature.switch(:feature_active, 1, 2)
          expect(retval).to eq(1)
        end

        it 'should return the second value if the feature is inactive' do
          retval = Feature.switch(:feature_inactive, 1, 2)
          expect(retval).to eq(2)
        end
      end

      context 'given a proc/lambda' do
        it 'should call the first proc/lambda if the feature is active' do
          retval = Feature.switch(:feature_active, -> { 1 }, -> { 2 })
          expect(retval).to eq(1)
        end

        it 'should call the second proc/lambda if the feature is active' do
          retval = Feature.switch(:feature_inactive, -> { 1 }, -> { 2 })
          expect(retval).to eq(2)
        end
      end
    end

    describe '#active_features' do
      it 'should return an array of active feature flags' do
        expect(Feature.active_features).to eq([:feature_active])
      end
    end

    describe '#inactive_features' do
      it 'should return an array of inactive feature flags' do
        expect(Feature.inactive_features).to eq([:feature_inactive])
      end
    end

    describe '#get' do
      it 'should return the state of the requested feature' do
        expect(Feature.get(:feature_active)).to eq(true)
        expect(Feature.get(:feature_inactive)).to eq(false)
      end
    end

    describe '#set' do
      context 'when the toggle exists' do
        it 'should update the state of the specified feature' do
          expect(Feature.get(:feature_active)).to eq(true)
          expect(Feature.set(:feature_active, false)).to eq(true)
          expect(Feature.get(:feature_active)).to eq(false)
        end
      end

      context 'when the toggle does not exist' do
        it 'should create the feature with the specified state' do
          expect(@repository).to receive(:create).with(:feature_missing, true).and_call_original
          expect(Feature.set(:feature_missing, true)).to eq(true)
          expect(Feature.get(:feature_missing)).to eq(true)
        end
      end
    end

    describe '#add' do
      it 'should create the feature with the specified state' do
        expect(@repository).to receive(:create).with(:feature_missing, true).and_call_original
        expect(Feature.add(:feature_missing, true)).to eq(true)
        expect(Feature.get(:feature_missing)).to eq(true)
      end

      it 'should create the feature with a default state of false' do
        expect(@repository).to receive(:create).with(:feature_missing, false).and_call_original
        expect(Feature.add(:feature_missing)).to eq(true)
        expect(Feature.get(:feature_missing)).to eq(false)
      end
    end

    describe '#create' do
      it 'should create the feature with the specified state' do
        expect(@repository).to receive(:create).with(:feature_missing, true).and_call_original
        expect(Feature.create(:feature_missing, true)).to eq(true)
        expect(Feature.get(:feature_missing)).to eq(true)
      end

      it 'should create the feature with a default state of false' do
        expect(@repository).to receive(:create).with(:feature_missing, false).and_call_original
        expect(Feature.create(:feature_missing)).to eq(true)
        expect(Feature.get(:feature_missing)).to eq(false)
      end
    end

    describe '#remove' do
      it 'should remove the feature' do
        expect(Feature.active_features).to include(:feature_active)
        expect(Feature.remove(:feature_active)).to eq(true)
        Feature.refresh!
        expect(Feature.active_features).not_to include(:feature_active)
        expect(Feature.inactive_features).not_to include(:feature_active)
      end
    end

    describe '#destroy' do
      it 'should remove the feature' do
        expect(Feature.active_features).to include(:feature_active)
        expect(Feature.destroy(:feature_active)).to eq(true)
        Feature.refresh!
        expect(Feature.active_features).not_to include(:feature_active)
        expect(Feature.inactive_features).not_to include(:feature_active)
      end
    end

    describe '#all' do
      it 'should return a hash of all defined features and their state' do
        expect(Feature.all).to eq(feature_active: true, feature_inactive: false)
      end
    end

    describe '#features' do
      it 'should return a hash of all defined features and their state' do
        expect(Feature.features).to eq(feature_active: true, feature_inactive: false)
      end
    end
  end
end
