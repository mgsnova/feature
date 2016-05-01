require 'spec_helper'

shared_examples_for 'a dynamic repository' do
  # define repo

  it 'should be able to create an active feature' do
    repo.create(:new_active_feature, true)
    expect(repo.get(:new_active_feature)).to eq true
  end

  it 'should be able to create an inactive feature' do
    repo.create(:new_inactive_feature, false)
    expect(repo.get(:new_inactive_feature)).to eq false
  end

  it 'should be able to add an active feature' do
    repo.set(:old_add_active_feature, true)
    expect(repo.get(:old_add_active_feature)).to eq true
  end

  it 'should be able to get an active features value' do
    repo.create(:active_feature, true)
    expect(repo.get(:active_feature)).to eq true
  end

  it 'should be able to get an inactive features value' do
    repo.create(:inactive_feature, false)
    expect(repo.get(:inactive_feature)).to eq false
  end

  it 'should be able to set a features value' do
    repo.create(:feature_c, true)
    repo.set(:feature_c, false)
    expect(repo.get(:feature_c)).to eq false
    repo.set(:feature_c, true)
    expect(repo.get(:feature_c)).to eq true
  end

  it 'should be able to delete a feature' do
    repo.create(:feature_d, true)
    expect(repo.features.include?(:feature_d)).to eq true
    expect(repo.destroy(:feature_d)).to eq true
  end

  it 'should raise an exception when adding not a symbol as active feature' do
    expect do
      repo.create('feature_a', true)
    end.to raise_error(ArgumentError, 'feature_a is not a symbol')
  end
end
