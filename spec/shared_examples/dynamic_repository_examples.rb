require 'spec_helper'

shared_examples_for 'a dynamic repository' do
  # define repo
  context 'after initialization' do
    it 'should have no active features' do
      expect(@repository.active_features).to eq([])
    end
  end

  context 'with features added' do
    it 'should be able to list all features' do
      repo.create_feature(:active_feature, true)
      repo.create_feature(:inactive_feature, false)
      expect(repo.list_features.sort).to eq [:active_feature, :inactive_feature].sort
    end

    it 'should be able to create an active feature' do
      repo.create_feature(:new_feature, true)
      expect(repo.get_feature(:new_feature)).to eq true
    end

    it 'should be able to create an inactive feature' do
      repo.create_feature(:new_feature, false)
      expect(repo.get_feature(:new_feature)).to eq false
    end

    it 'should be able to add an active feature' do
      repo.add_active_feature(:new_feature)
      expect(repo.get_feature(:new_feature)).to eq true
    end

    it 'should be able to add an inactive feature' do
      repo.add_inactive_feature(:new_feature)
      expect(repo.get_feature(:new_feature)).to eq false
    end

    it 'should be able to get a features value' do
      repo.create_feature(:active_feature, true)
      repo.create_feature(:inactive_feature, false)
      expect(repo.get_feature(:active_feature)).to eq true
      expect(repo.get_feature(:inactive_feature)).to eq false
    end

    it 'should be able to set a features value' do
      repo.create_feature(:active_feature, true)
      repo.create_feature(:inactive_feature, false)
      repo.set_feature(:active_feature, false)
      expect(repo.get_feature(:active_feature)).to eq false
      repo.set_feature(:active_feature, true)
      expect(repo.get_feature(:active_feature)).to eq true
    end

    it 'should be able to delete a feature' do
      repo.create_feature(:active_feature, true)
      repo.create_feature(:inactive_feature, false)
      expect(repo.list_features.include?(:active_feature)).to eq true
      expect(repo.remove_feature(:active_feature)).to eq true
    end

    it 'should raise an exception when adding not a symbol as active feature' do
      expect do
        repo.add_active_feature 'feature_a'
      end.to raise_error(ArgumentError, 'feature_a is not a symbol')
    end

    it 'should raise an exception when adding a active feature already added as active' do
      repo.add_active_feature :feature_a
      expect do
        repo.add_active_feature :feature_a
      end.to raise_error(ArgumentError, 'feature :feature_a already added')
    end
  end
end
