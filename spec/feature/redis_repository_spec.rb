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
      repository.create(:feature_a_inactive, false)
      repository.create(:feature_b_inactive, false)
      repository.create(:feature_a_active, true)
      repository.create(:feature_b_active, true)
      repository
    end
  end

  let(:specified_redis) { double }
  let(:redis_key) { 'application_features' }
  let(:repo) { RedisRepository.new(redis_key, specified_redis) }
  it 'should allow you to specify the redis instance to use' do
    expect(repo.send(:redis)).to eq specified_redis
  end

  describe '#get' do
    subject { repo.get(feature_name) }
    context 'when the stored value is not nil, "true" or "false"' do
      let(:stored_value) { 'bad_value' }
      let(:feature_name) { :my_feature }

      before do
        allow(specified_redis).to receive(:hget).with(redis_key, feature_name.to_s)
          .and_return(stored_value)
      end

      it 'should raise an error' do
        expect{subject}.to raise_error(ArgumentError)
      end
    end
  end
end
