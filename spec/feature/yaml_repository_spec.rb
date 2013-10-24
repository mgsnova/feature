require 'spec_helper'
require 'tempfile'

include Feature::Repository

describe Feature::Repository::YamlRepository do
  context "proper config file" do
    before(:each) do
      @filename = Tempfile.new(['feature_config', '.yaml']).path
      fp = File.new(@filename, 'w')
      fp.write <<"EOF";
features:
    feature_a_active: true
    feature_b_active: true
    feature_c_inactive: false
    feature_d_inactive: false
EOF
      fp.close

      @repo = YamlRepository.new(@filename)
    end

    after(:each) do
      File.delete(@filename)
    end

    it "should read active features from a config file" do
      @repo.active_features.should == [:feature_a_active, :feature_b_active]
    end

    context "re-read config file" do
      before(:each) do
        fp = File.new(@filename, 'w')
        fp.write <<"EOF";
features:
    feature_a_active: true
    feature_c_inactive: false
EOF
        fp.close
      end

      it "should read active features new on each request" do
        @repo.active_features.should == [:feature_a_active]
      end
    end

    # For example, when all your features are in production and working fine.
    context "with no features" do
      before(:each) do
        fp = File.new(@filename, 'w')
        fp.write <<"EOF";
features:
EOF
        fp.close
      end

      it "should read active features new on each request" do
        @repo.active_features.should == []
      end
    end

    # Sometimes needed when loading features from ENV variables or are time
    # based rules Ex: Date.today > Date.strptime('1/2/2012', '%d/%m/%Y')
    context "a config file with embedded erb" do
      before(:each) do
        @filename = Tempfile.new(['feature_config', '.yaml']).path
        fp = File.new(@filename, 'w')
        fp.write <<"EOF";
features:
    feature_a_active: <%= 'true' == 'true' %>
    feature_b_active: true
    feature_c_inactive: <%= false %>
    feature_d_inactive: <%= 1 < 0 %>
EOF
        fp.close

        @repo = YamlRepository.new(@filename)
      end

      it "should read active features from the config file" do
        @repo.active_features.should == [:feature_a_active, :feature_b_active]
      end
    end
  end

  it "should raise exception on no file found" do
    repo = YamlRepository.new("/this/file/should/not/exist")
    lambda do
      repo.active_features
    end.should raise_error(Errno::ENOENT, /No such file or directory/)
  end

  it "should raise exception on invalid yaml" do
    @filename = Tempfile.new(['feature_config', '.yaml']).path
    fp = File.new(@filename, 'w')
    fp.write "this is not valid feature config"
    fp.close

    repo = YamlRepository.new(@filename)
    lambda do
      repo.active_features
    end.should raise_error(ArgumentError, "content of #{@filename} does not contain proper config")
  end

  it "should raise exception on not true/false value in config" do
    @filename = Tempfile.new(['feature_config', '.yaml']).path
    fp = File.new(@filename, 'w')
    fp.write <<"EOF";
features:
    invalid_feature: neither_true_or_false
EOF
    fp.close

    repo = YamlRepository.new(@filename)
    lambda do
      repo.active_features
    end.should raise_error(ArgumentError, "neither_true_or_false is not allowed value in config, use true/false")
  end
end
