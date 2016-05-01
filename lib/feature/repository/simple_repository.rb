module Feature
  module Repository
    # SimpleRepository for active feature list
    # Simply add features to that should be active,
    # no config or data sources required.
    #
    # Example usage:
    #   repository = SimpleRepository.new
    #   repository.create(:feature_name)
    #   # use repository with Feature
    #
    class SimpleRepository
      # Constructor
      #
      def initialize
        @active_features = []
        @inactive_features = []
      end

      # Remove a feature from a repository
      #
      # @param [Symbol] feature the feature to be removed
      #
      def destroy(feature)
        @active_features -= [feature]
        @inactive_features -= [feature]
        true
      end

      # Get the value of feature from a repository
      #
      # @param [Symbol] feature the feature to be checked
      # @return [Boolean] whether the feature is active
      def get(feature)
        @active_features.include?(feature)
      end

      # Add a feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def create(feature, val=false)
        check_feature_is_not_symbol(feature)
        val ? (@active_features << feature) : (@inactive_features << feature)
      end

      # Set the value of feature in a repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def set(feature, val)
        check_feature_is_not_symbol(feature)
        destroy(feature)
        create(feature, val)
      end

      # List all of the features in a repository
      #
      # @return [Array<Symbol>] list of all features
      #
      def features
        active = active_features.inject({}) { |a, e| a.merge(e => true) }
        inactive = inactive_features.inject({}) { |a, e| a.merge(e => false) }
        active.merge(inactive)
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
        raise ArgumentError, "#{feature} is not a symbol" unless feature.instance_of?(Symbol)
      end
      private :check_feature_is_not_symbol
    end
  end
end
