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
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        @active_features.dup
      end

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def add_active_feature(feature)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        @active_features << feature
      end

      # Checks that given feature is a symbol, raises exception otherwise
      #
      # @param [Sybmol] feature the feature to be checked
      #
      def check_feature_is_not_symbol(feature)
        raise ArgumentError, "#{feature} is not a symbol" unless feature.instance_of?(Symbol)
      end
      private :check_feature_is_not_symbol

      # Checks if given feature is already added to list of active features
      # and raises an exception if so
      #
      # @param [Symbol] feature the feature to be checked
      #
      def check_feature_already_in_list(feature)
        raise ArgumentError, "feature :#{feature} already added" if @active_features.include?(feature)
      end
      private :check_feature_already_in_list
    end
  end
end
