require 'spec_helper'

describe Feature do
  context "without FeatureRepository" do
    it "should raise an exception when calling active?" do
      lambda do
        Feature.active?(:feature_a)
      end.should raise_error("Feature is missing Repository for obtaining feature lists")
    end

    it "should raise an exception when calling inactive?" do
      lambda do
        Feature.inactive?(:feature_a)
      end.should raise_error("Feature is missing Repository for obtaining feature lists")
    end

    it "should raise an exception when calling with" do
      lambda do
        Feature.with(:feature_a) do
        end
      end.should raise_error("Feature is missing Repository for obtaining feature lists")
    end

    it "should raise an exception when calling without" do
      lambda do
        Feature.without(:feature_a) do
        end
      end.should raise_error("Feature is missing Repository for obtaining feature lists")
    end
  end

  context "setting Repository" do
    before(:each) do
      @repository = Feature::Repository::SimpleRepository.new
      Feature.set_repository @repository
    end

    it "should raise an exception when add repository with wrong class" do
      lambda do
        Feature.set_repository("not a repository")
      end.should raise_error(ArgumentError, "given repository does not respond to active_features")
    end

    it "should set a feature repository" do
      lambda do
        Feature.active?(:feature_a)
      end.should_not raise_error

      lambda do
        Feature.inactive?(:feature_a)
      end.should_not raise_error
    end

    it "should get active features from repository once" do
      @repository.add_active_feature(:feature_a)
      Feature.active?(:feature_a).should be_false
    end
  end

  context "refresh features" do
    before(:each) do
      @repository = Feature::Repository::SimpleRepository.new
      Feature.set_repository @repository
    end

    it "should refresh active feature lists from repository" do
      @repository.add_active_feature(:feature_a)
      Feature.refresh!
      Feature.active?(:feature_a).should be_true
    end
  end

  context "request features" do
    before(:each) do
      repository = Feature::Repository::SimpleRepository.new
      repository.add_active_feature :feature_active
      Feature.set_repository repository
    end

    it "should affirm active feature is active" do
      Feature.active?(:feature_active).should be_true
    end

    it "should not affirm active feature is inactive" do
      Feature.inactive?(:feature_active).should be_false
    end

    it "should affirm inactive feature is inactive" do
      Feature.inactive?(:feature_inactive).should be_true
    end

    it "should not affirm inactive feature is active" do
      Feature.active?(:feature_inactive).should be_false
    end

    it "should call block with active feature in active list" do
      reached = false

      Feature.with(:feature_active) do
        reached = true
      end

      reached.should be_true
    end

    it "should not call block with active feature not in active list" do
      reached = false

      Feature.with(:feature_inactive) do
        reached = true
      end

      reached.should be_false
    end

    it "should raise exception when no block given to with" do
      lambda do
        Feature.with(:feature_active)
      end.should raise_error(ArgumentError, "no block given to with")
    end

    it "should call block without inactive feature in inactive list" do
      reached = false

      Feature.without(:feature_inactive) do
        reached = true
      end

      reached.should be_true
    end

    it "should not call block without inactive feature in inactive list" do
      reached = false

      Feature.without(:feature_active) do
        reached = true
      end

      reached.should be_false
    end

    it "should raise exception when no block given to without" do
      lambda do
        Feature.without(:feature_inactive)
      end.should raise_error(ArgumentError, "no block given to without")
    end

  end
end
