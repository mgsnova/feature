require 'spec_helper'

include Feature::Repository

describe Feature::Repository::RedisRepository do
  before(:each) do
    @repository = RedisRepository.new('application_features')
  end

  it 'should have no active features after initialization' do
    expect(@repository.active_features).to eq([])
  end

  it 'should add an active feature' do
    @repository.add_active_feature :feature_a
    expect(@repository.active_features).to eq([:feature_a])
  end

  it 'should only show active feature' do
    Redis.current.hset('application_features', 'inactive_a', false)
    Redis.current.hset('application_features', 'inactive_b', false)
    Redis.current.hset('application_features', 'feature_a', true)
    Redis.current.hset('application_features', 'feature_b', true)

    expect(@repository.active_features).to eq([:feature_a, :feature_b])
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

  let(:specified_redis) { double }
  let(:repo) { RedisRepository.new('application_features', specified_redis) }
  it 'should allow you to specify the redis instance to use' do
    expect(repo.send(:redis)).to eq specified_redis
  end
end
