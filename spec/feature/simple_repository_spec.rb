require 'spec_helper'

include Feature::Repository

describe Feature::Repository::SimpleRepository do
  before(:each) do
    @repository = SimpleRepository.new
  end

  it_behaves_like 'a dynamic repository' do
    let(:repo) { SimpleRepository.new }
  end

  it_behaves_like 'a repository' do
    let(:repo) do
      repository = SimpleRepository.new
      repository.create_feature(:feature_a_inactive, false)
      repository.create_feature(:feature_b_inactive, false)
      repository.create_feature(:feature_a_active, true)
      repository.create_feature(:feature_b_active, true)
      repository
    end
  end

  it 'should have no active features after initialization' do
    expect(@repository.active_features).to eq([])
  end

  it 'should add an active feature' do
    @repository.add_active_feature :feature_a
    expect(@repository.active_features).to eq([:feature_a])
  end

  it 'should add an feature without having impact on internal structure' do
    list = @repository.active_features
    @repository.add_active_feature :feature_a
    expect(list).to eq([])
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
end
