module Feature
  module Repository
    ##
    # SimpleRepository for active and inactive feature list
    # Simply add features to both lists, not config or data sources required
    #
    class SimpleRepository < AbstractRepository
      ##
      # Constructor
      #
      def initialize
        @active_features = []
        @inactive_features = []
      end

      ##
      # Returns list of active features
      #
      #   @return   Array<Symbol>
      #
      def active_features
        @active_features.dup
      end

      ##
      # Returns list of inactive features
      #
      #   @return   Array<Symbol>
      #
      def inactive_features
        @inactive_features.dup
      end

      ##
      # Add an active feature
      #
      #   @param    Sybmol, feature
      #
      def add_active_feature(feature)
        check_feature_is_symbol(feature)
        check_feature_already_in_lists(feature)
        @active_features << feature
      end

      ##
      # Add an inactive feature
      #
      #   @param    Sybmol, feature
      #
      def add_inactive_feature(feature)
        check_feature_is_symbol(feature)
        check_feature_already_in_lists(feature)
        @inactive_features << feature
      end

      ##
      # Checks if the given feature is a symbol and raises and raises an exception if so
      #
      #   @param    Sybmol, feature
      #
      def check_feature_is_symbol(feature)
        if !feature.is_a?(Symbol)
          raise ArgumentError, "given feature #{feature} is not a symbol"
        end
      end
      private :check_feature_is_symbol

      ##
      # Checks if given feature is already added to list of active or inactive features
      # and raises an exception if so
      #
      #   @param    Symbol, feature
      #
      def check_feature_already_in_lists(feature)
        if @active_features.include?(feature)
          raise ArgumentError, "feature :#{feature} already added to list of active features"
        end

        if @inactive_features.include?(feature)
          raise ArgumentError, "feature :#{feature} already added to list of inactive features"
        end
      end
      private :check_feature_already_in_lists
    end
  end
end
