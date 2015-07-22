require 'spec_helper'
require 'tempfile'

include Feature::Repository

describe Feature::Repository::YamlRepository do
  context 'proper config file' do
    before(:each) do
      @filename = Tempfile.new(['feature_config', '.yaml']).path
      fp = File.new(@filename, 'w')
      fp.write <<"EOF"
features:
    feature_a_active: true
    feature_b_active: true
    feature_a_inactive: false
    feature_b_inactive: false
EOF
      fp.close

      @repo = YamlRepository.new(@filename)
    end

    after(:each) do
      File.delete(@filename)
    end

    it_behaves_like 'a repository' do
      let(:repo) { @repo }
    end

    context 're-read config file' do
      before(:each) do
        fp = File.new(@filename, 'w')
        fp.write <<"EOF"
features:
    feature_a_active: true
    feature_c_inactive: false
EOF
        fp.close
      end

      it 'should read active features new on each request' do
        expect(@repo.active_features).to eq([:feature_a_active])
      end
    end

    context 'with no features' do
      before(:each) do
        fp = File.new(@filename, 'w')
        fp.write <<"EOF"
features:
EOF
        fp.close
      end

      it 'should read active features new on each request' do
        expect(@repo.active_features).to eq([])
      end
    end

    context 'with optional environment name' do
      before(:each) do
        fp = File.new(@filename, 'w')
        fp.write <<"EOF"
development:
  features:
      feature_a: true
      feature_b: true
production:
  features:
      feature_a: true
      feature_b: false
EOF
        fp.close
      end

      it 'has two active features for development environment' do
        repo = YamlRepository.new(@filename, 'development')
        expect(repo.active_features).to eq([:feature_a, :feature_b])
      end

      it 'has one active feature for production environment' do
        repo = YamlRepository.new(@filename, 'production')
        expect(repo.active_features).to eq([:feature_a])
      end
    end

    # Sometimes needed when loading features from ENV variables or are time
    # based rules Ex: Date.today > Date.strptime('1/2/2012', '%d/%m/%Y')
    context 'a config file with embedded erb' do
      before(:each) do
        @filename = Tempfile.new(['feature_config', '.yaml']).path
        fp = File.new(@filename, 'w')
        fp.write <<"EOF"
features:
    feature_a_active: <%= 'true' == 'true' %>
    feature_b_active: true
    feature_c_inactive: <%= false %>
    feature_d_inactive: <%= 1 < 0 %>
EOF
        fp.close

        @repo = YamlRepository.new(@filename)
      end

      it 'should read active features from the config file' do
        expect(@repo.active_features).to eq([:feature_a_active, :feature_b_active])
      end
    end
  end

  it 'should raise exception on no file found' do
    repo = YamlRepository.new('/this/file/should/not/exist')
    expect do
      repo.active_features
    end.to raise_error(Errno::ENOENT, /No such file or directory/)
  end

  it 'should raise exception on invalid yaml' do
    @filename = Tempfile.new(['feature_config', '.yaml']).path
    fp = File.new(@filename, 'w')
    fp.write 'this is not valid feature config'
    fp.close

    repo = YamlRepository.new(@filename)
    expect do
      repo.active_features
    end.to raise_error(ArgumentError, 'yaml config does not contain proper config')
  end

  it 'should raise exception on yaml without features key' do
    @filename = Tempfile.new(['feature_config', '.yaml']).path
    fp = File.new(@filename, 'w')
    fp.write <<"EOF"
fail:
    feature: true
EOF
    fp.close

    repo = YamlRepository.new(@filename)
    expect do
      repo.active_features
    end.to raise_error(ArgumentError, 'yaml config does not contain proper config')
  end

  it 'should raise exception on not true/false value in config' do
    @filename = Tempfile.new(['feature_config', '.yaml']).path
    fp = File.new(@filename, 'w')
    fp.write <<"EOF"
features:
    invalid_feature: neither_true_or_false
EOF
    fp.close

    repo = YamlRepository.new(@filename)
    expect do
      repo.active_features
    end.to raise_error(ArgumentError, 'neither_true_or_false is not allowed value in config, use true/false')
  end
end
