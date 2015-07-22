module Feature
  module Repository
    # SimpleRepository for active feature list
    # Simply add features to that should be active,
    # no config or data sources required.
    #
    # Example usage:
    #   repository = SimpleRepository.new
    #   repository.add_active_feature(:feature_name)
    #   # use repository with Feature
    #
    class SimpleRepository
      # Constructor
      #
      def initialize
        @active_features = []
        @inactive_features = []
      end

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def add_active_feature(feature)
        create_feature(feature, true)
      end

      # Remove a feature from a repository
      #
      # @param [Symbol] feature the feature to be removed
      #
      def remove_feature(feature)
        @active_features -= [feature]
        @inactive_features -= [feature]
        true
      end

      # Get the value of feature from a repository
      #
      # @param [Symbol] feature the feature to be checked
      # @return [Boolean] whether the feature is active
      def get_feature(feature)
        @active_features.include?(feature)
      end

      # Add a feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def create_feature(feature, val)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        val ? (@active_features << feature) : (@inactive_features << feature)
      end

      # Set the value of feature in a repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def set_feature(feature, val)
        remove_feature(feature)
        create_feature(feature, val)
      end

      # List all of the features in a repository
      #
      # @return [Array<Symbol>] list of all features
      #
      def features
        active_features + inactive_features
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        @active_features.dup
      end

      # Returns list of inactive features
      #
      # @return [Array<Symbol>] list of inactive features
      #
      def inactive_features
        @inactive_features.dup
      end

      # Checks that given feature is a symbol, raises exception otherwise
      #
      # @param [Sybmol] feature the feature to be checked
      #
      def check_feature_is_not_symbol(feature)
        fail ArgumentError, "#{feature} is not a symbol" unless feature.instance_of?(Symbol)
      end
      private :check_feature_is_not_symbol

      # Checks if given feature is already added to list of active features
      # and raises an exception if so
      #
      # @param [Symbol] feature the feature to be checked
      #
      def check_feature_already_in_list(feature)
        fail ArgumentError, "feature :#{feature} already added" if features.include?(feature)
      end
      private :check_feature_already_in_list
    end
  end
end
