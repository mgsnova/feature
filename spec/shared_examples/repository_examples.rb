require 'spec_helper'

shared_examples_for 'a repository' do
  # define repo with the following active features: :feature_a_active, :feature_b_active
  #            and the following inactive features: :feature_a_inactive, :feature_b_inactive

  it 'should be able to return a hash of all features and their current state' do
    features = {
      feature_a_active: true,
      feature_a_inactive: false,
      feature_b_active: true,
      feature_b_inactive: false
    }
    expect(repo.features).to eq features
  end

  it '#active_features should only show active features' do
    expect(repo.active_features.sort).to eq([:feature_a_active, :feature_b_active].sort)
  end

  it '#inactive_features should only show active features' do
    expect(repo.inactive_features.sort).to eq([:feature_a_inactive, :feature_b_inactive].sort)
  end

  it '#get should only show active features' do
    expect(repo.get(:feature_a_inactive)).to eq false
    expect(repo.get(:feature_a_active)).to eq true
    expect(repo.get(:feature_b_inactive)).to eq false
    expect(repo.get(:feature_b_active)).to eq true
  end

  it '#get should return false when the feature does not exist' do
    expect(repo.get(:undefined_feature)).to eq false
  end
end
