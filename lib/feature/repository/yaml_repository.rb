module Feature
  module Repository
    ##
    # YamlRepository for active and inactive feature list
    # The yaml config file should look like this:
    #
    #     features:
    #         an_active_feature: true
    #         an_inactive_feature: false
    #
    class YamlRepository < AbstractRepository
      require 'yaml'

      ##
      # Constructor
      #
      #   @param    String, yaml_file_name
      #
      def initialize(yaml_file_name)
        @yaml_file_name = yaml_file_name
      end

      ##
      # Returns list of active features
      #
      #   @return   Array<Symbol>
      #
      def active_features
        get_active_features_from_file
      end

      ##
      # Return a list of active features read from the config file
      #
      #   @return   Array<Symbol>
      #
      def get_active_features_from_file
        features_hash = read_and_parse_file_data
        features = features_hash.keys.select { |feature_key| features_hash[feature_key] }
        features.sort.map(&:to_sym)
      end
      private :get_active_features_from_file

      ##
      # Returns list of inactive features
      #
      #   @return   Array<Symbol>
      #
      def inactive_features
        get_inactive_features_from_file
      end

      ##
      # Return a list of inactive features read from the config file
      #
      #   @return   Array<Symbol>
      #
      def get_inactive_features_from_file
        features_hash = read_and_parse_file_data
        features = features_hash.keys.select { |feature_key| !features_hash[feature_key] }
        features.sort.map(&:to_sym)
      end
      private :get_inactive_features_from_file

      ##
      # Read and parses the feature config file
      #
      #   @return   Hash (with :feature => true/false meaning active/inactive)
      #
      def read_and_parse_file_data
        raw_data = File.read(@yaml_file_name)
        data = YAML.load(raw_data)
        if !data.is_a?(Hash) or !data.has_key?('features')
          raise ArgumentError, "content of #{@yaml_file_name} does not contain proper config"
        end
        data['features']
      end
      private :read_and_parse_file_data
    end
  end
end
