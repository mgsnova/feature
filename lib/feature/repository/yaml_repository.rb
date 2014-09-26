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
    class YamlRepository
      require 'erb'
      require 'yaml'

      # Constructor
      #
      # @param [String] yaml_file_name the yaml config filename
      # @param [String] environment optional environment to use from config
      #
      def initialize(yaml_file_name, environment='')
        @yaml_file_name = yaml_file_name
        @environment = environment
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        features_hash = read_and_parse_file_data
        features = features_hash.keys.select { |feature_key| features_hash[feature_key] }
        features.sort.map(&:to_sym)
      end

      # Read and parses the feature config file
      #
      # @return [Hash] Hash containing :feature => true/false entries for representing active/inactive features
      #
      def read_and_parse_file_data
        raw_data = File.read(@yaml_file_name)
        evaluated_data = ERB.new(raw_data).result
        data = YAML.load(evaluated_data)
        data = data[@environment] unless @environment.empty?

        if !data.is_a?(Hash) or !data.has_key?('features')
          raise ArgumentError, "content of #{@yaml_file_name} does not contain proper config"
        end

        if data['features']
          invalid_value = data['features'].values.detect { |value| ![true, false].include?(value) }
          if invalid_value
            raise ArgumentError, "#{invalid_value} is not allowed value in config, use true/false"
          end

          data['features']
        else
          {}
        end
      end
      private :read_and_parse_file_data
    end
  end
end
