module Feature
  module Repository
    # YamlRepository for active and inactive features
    # The yaml config file should look like this:
    #
    #   features:
    #       an_active_feature: true
    #       an_inactive_feature: false
    #
    # Example usage:
    #   repository = YamlRepository.new('/path/to/yaml/file')
    #   # use repository with Feature
    #
    # A yaml config also can have this format:
    #   features:
    #     development:
    #       a_feature: true
    #     production:
    #       a_feature: false
    #
    # This way you have to use:
    #   repository = YamlRepository.new('/path/to/yaml/file', '_your_environment_')
    #   # use repository with Feature
    #
    class YamlRepository
      require 'erb'
      require 'yaml'

      # Constructor
      #
      # @param [String] yaml_file_name the yaml config filename
      # @param [String] environment optional environment to use from config
      #
      def initialize(yaml_file_name, environment = '')
        @yaml_file_name = yaml_file_name
        @environment = environment
      end

      # Get the value of feature from a repository
      #
      # @param [Symbol] feature the feature to be checked
      # @return [Boolean] whether the feature is active
      #
      def get_feature(feature)
        active_features.include?(feature)
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        data_hash = get_feature_hash(read_file(@yaml_file_name), @environment)
        data_hash.select { |_, v| v }.keys.map(&:to_sym)
      end

      # Returns list of inactive features
      #
      # @return [Array<Symbol>] list of active features
      #
      def inactive_features
        data_hash = get_feature_hash(read_file(@yaml_file_name), @environment)
        data_hash.select { |_, v| !v }.keys.map(&:to_sym)
      end

      # Returns list of all features
      #
      # @return [Array<Symbol>] list of active features
      #
      def list_features
        data_hash = get_feature_hash(read_file(@yaml_file_name), @environment)
        data_hash.keys.map(&:to_sym)
      end

      # Read given file, perform erb evaluation and yaml parsing
      #
      # @param file_name [String] the file name fo the yaml config
      # @return [Hash]
      #
      def read_file(file_name)
        raw_data = File.read(file_name)
        evaluated_data = ERB.new(raw_data).result
        YAML.load(evaluated_data)
      end
      private :read_file

      # Extracts features hash from given yaml
      #
      # @param data [Hash] hash parsed from yaml file
      # @param selector [String] uses the value for this key as source of feature data
      #
      def get_feature_hash(data, selector)
        data = data[selector] unless selector.empty?

        if !data.is_a?(Hash) || !data.key?('features')
          fail ArgumentError, 'yaml config does not contain proper config'
        end

        return {} unless data['features']

        check_valid_feature_data(data['features'])

        data['features']
      end
      private :get_feature_hash

      # Checks for valid values in given feature hash
      #
      # @param features [Hash] feature hash
      #
      def check_valid_feature_data(features)
        features.values.each do |value|
          unless [true, false].include?(value)
            fail ArgumentError, "#{value} is not allowed value in config, use true/false"
          end
        end
      end
    end
  end
end
