require 'spec_helper'

include Feature::Repository

describe Feature::Repository::RedisRepository do
  before(:each) do
    @repository = RedisRepository.new('application_features')
  end

  it_behaves_like 'a dynamic repository' do
    let(:repo) { RedisRepository.new('application_features') }
  end

  it_behaves_like 'a repository' do
    let(:repo) do
      repository = RedisRepository.new('application_features')
      repository.create_feature(:feature_a_inactive, false)
      repository.create_feature(:feature_b_inactive, false)
      repository.create_feature(:feature_a_active, true)
      repository.create_feature(:feature_b_active, true)
      repository
    end
  end

  let(:specified_redis) { double }
  let(:repo) { RedisRepository.new('application_features', specified_redis) }
  it 'should allow you to specify the redis instance to use' do
    expect(repo.redis).to eq specified_redis
  end
end
