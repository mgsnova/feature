require 'spec_helper'

describe Feature do
  context 'without FeatureRepository' do
    it 'should raise an exception when calling active?' do
      expect do
        Feature.active?(:feature_a)
      end.to raise_error('missing Repository for obtaining feature lists')
    end

    it 'should raise an exception when calling active_features' do
      expect do
        Feature.active_features
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
        @repository.add_active_feature(:feature_a)
        # the line below will be the first usage of feature in this case
        expect(Feature.active?(:feature_a)).to be_truthy
      end

      it 'should get active features from repository once' do
        Feature.active?(:does_not_matter)
        @repository.add_active_feature(:feature_a)
        expect(Feature.active?(:feature_a)).to be_falsey
      end

      it 'should reload active features on first call only' do
        @repository.add_active_feature(:feature_a)
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
        @repository.add_active_feature(:feature_a)
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
      @repository.add_active_feature(:feature_a)
      Feature.refresh!
      expect(Feature.active?(:feature_a)).to be_truthy
    end
  end

  context 'request features' do
    before(:each) do
      repository = Feature::Repository::SimpleRepository.new
      repository.add_active_feature :feature_active
      Feature.set_repository repository
    end

    it 'should affirm active features' do
      expect(Feature.active_features.count).to eq(1)
      expect(Feature.active_features.include? :feature_active).to be_truthy
      expect(Feature.active_features.include? :feature_inactive).to be_falsey
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

    describe 'switch()' do
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
  end
end
