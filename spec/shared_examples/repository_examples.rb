require 'spec_helper'

shared_examples_for "a repository" do
  # define repo with the following active features: :feature_a_active, :feature_b_active
  #            and the following inactive features: :feature_a_inactive, :feature_b_inactive


  it '#active_features should only show active features' do
    expect(repo.active_features).to eq([:feature_a_active, :feature_b_active])
  end

  it '#inactive_features should only show active features' do
    expect(repo.inactive_features).to eq([:feature_a_inactive, :feature_b_inactive])
  end

  it '#get_feature should only show active features' do
    expect(repo.get_feature(:feature_a_inactive)).to eq false
    expect(repo.get_feature(:feature_a_active)).to eq true
    expect(repo.get_feature(:feature_b_inactive)).to eq false
    expect(repo.get_feature(:feature_b_active)).to eq true
  end

  it "#list_features should list all features" do
    expect(repo.list_features.sort).to eq [:feature_a_active, :feature_b_active, :feature_a_inactive, :feature_b_inactive].sort
  end
end