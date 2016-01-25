require 'spec_helper'

shared_examples_for 'a dynamic repository' do
  # define repo

  it 'should be able to create an active feature' do
    repo.create_feature(:new_active_feature, true)
    expect(repo.get_feature(:new_active_feature)).to eq true
  end

  it 'should be able to create an inactive feature' do
    repo.create_feature(:new_inactive_feature, false)
    expect(repo.get_feature(:new_inactive_feature)).to eq false
  end

  it 'should be able to add an active feature' do
    repo.add_active_feature(:old_add_active_feature)
    expect(repo.get_feature(:old_add_active_feature)).to eq true
  end

  it 'should be able to get an active features value' do
    repo.create_feature(:active_feature, true)
    expect(repo.get_feature(:active_feature)).to eq true
  end

  it 'should be able to get an inactive features value' do
    repo.create_feature(:inactive_feature, false)
    expect(repo.get_feature(:inactive_feature)).to eq false
  end

  it 'should be able to set a features value' do
    repo.create_feature(:feature_c, true)
    repo.set_feature(:feature_c, false)
    expect(repo.get_feature(:feature_c)).to eq false
    repo.set_feature(:feature_c, true)
    expect(repo.get_feature(:feature_c)).to eq true
  end

  it 'should be able to delete a feature' do
    repo.create_feature(:feature_d, true)
    expect(repo.features.include?(:feature_d)).to eq true
    expect(repo.remove_feature(:feature_d)).to eq true
  end

  it 'should raise an exception when adding not a symbol as active feature' do
    expect do
      repo.add_active_feature 'feature_a'
    end.to raise_error(ArgumentError, 'feature_a is not a symbol')
  end

  it 'should raise an exception when adding a active feature already added as active' do
    repo.add_active_feature :feature_f
    expect do
      repo.add_active_feature :feature_f
    end.to raise_error(ArgumentError, 'feature :feature_f already added')
  end
end
