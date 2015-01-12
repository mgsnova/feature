require 'spec_helper'

include Feature::Repository

describe Feature::Repository::RedisRepository do
  before(:each) do
    @repository = RedisRepository.new('application_features')
  end

  it 'should have no active features after initialization' do
    expect(@repository.active_features).to eq([])
  end

  context '#remove_feature' do
    it 'should remove an active feature' do
      Redis.current.hset('application_features', 'feature_a', true)
      @repository.remove_feature :feature_a
      expect(@repository.active_features).to eq([])
    end
    it 'should remove an inactive feature' do
      Redis.current.hset('application_features', 'feature_a', false)
      @repository.remove_feature :feature_a
      expect(@repository.active_features).to eq([])
    end
    it 'should fail if feature does not exist' do
      expect { @repository.remove_feature :feature_a }.to raise_error ArgumentError
    end
  end

  context '#all_features' do
    it 'should return a hash of all feature' do
      Redis.current.hset('application_features', 'inactive_a', false)
      Redis.current.hset('application_features', 'inactive_b', false)
      Redis.current.hset('application_features', 'feature_a', true)
      Redis.current.hset('application_features', 'feature_b', true)

      expect(@repository.all_features).to eq('inactive_a' => 'false',
                                             'inactive_b' => 'false',
                                             'feature_a' => 'true',
                                             'feature_b' => 'true')
    end
  end

  context '#add_active_feature' do
    it 'should add an active feature' do
      @repository.add_active_feature :feature_a
      expect(@repository.active_features).to eq([:feature_a])
    end
    it 'should coerce input type into a symbol' do
      @repository.add_active_feature 'feature_a'
      expect(@repository.active_features).to eq([:feature_a])
    end
  end

  context '#add_inactive_feature' do
    it 'should add an inactive feature' do
      @repository.add_inactive_feature :feature_a
      expect(@repository.active_features).to eq([])
      expect(@repository.all_features).to eq('feature_a' => 'false')
    end
    it 'should coerce input type into a symbol' do
      @repository.add_inactive_feature 'feature_a'
      expect(@repository.all_features).to eq('feature_a' => 'false')
    end
  end

  context '#active_features' do
    it 'should only show active feature' do
      Redis.current.hset('application_features', 'inactive_a', false)
      Redis.current.hset('application_features', 'inactive_b', false)
      Redis.current.hset('application_features', 'feature_a', true)
      Redis.current.hset('application_features', 'feature_b', true)

      expect(@repository.active_features).to eq([:feature_a, :feature_b])
    end
    it 'should coerce input type into a symbol' do
      @repository.add_active_feature 'feature_a'
      expect(@repository.active_features).to eq([:feature_a])
    end
    it 'should raise an exception when adding a active feature already added as active' do
      @repository.add_active_feature :feature_a
      expect do
        @repository.add_active_feature :feature_a
      end.to raise_error(ArgumentError, 'feature :feature_a already added')
    end
  end

  context '#activate_feature' do
    it 'should activate inactive feature' do
      @repository.add_inactive_feature :feature_a
      @repository.activate_feature :feature_a
      expect(@repository.all_features).to eq('feature_a' => 'true')
    end
    it 'should leave active feature alone' do
      @repository.add_active_feature :feature_a
      @repository.activate_feature :feature_a
      expect(@repository.all_features).to eq('feature_a' => 'true')
    end
    it 'should fail if feature does not exist' do
      expect { @repository.activate_feature :feature_a }.to raise_error ArgumentError
    end
    it 'should coerce input type into a symbol' do
      @repository.add_inactive_feature :feature_a
      @repository.activate_feature 'feature_a'
      expect(@repository.all_features).to eq('feature_a' => 'true')
    end
  end

  context '#deactivate_feature' do
    it 'should deactivate active feature' do
      @repository.add_active_feature :feature_a
      @repository.deactivate_feature :feature_a
      expect(@repository.all_features).to eq('feature_a' => 'false')
    end
    it 'should leave inactive feature alone' do
      @repository.add_inactive_feature :feature_a
      @repository.deactivate_feature :feature_a
      expect(@repository.all_features).to eq('feature_a' => 'false')
    end
    it 'should fail if feature does not exist' do
      expect { @repository.deactivate_feature :feature_a }.to raise_error ArgumentError
    end
    it 'should coerce input type into a symbol' do
      @repository.add_active_feature :feature_a
      @repository.deactivate_feature 'feature_a'
      expect(@repository.all_features).to eq('feature_a' => 'false')
    end
  end
end
