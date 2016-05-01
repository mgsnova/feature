module Feature
  module Repository
    # AcitveRecordRepository for active feature list
    # Right now we assume you have at least name:string and active:boolean
    # defined in your table.
    #
    # Example usage:
    #   repository = ActiveRecordRepository.new(FeatureToggle)
    #   repository.add_active_feature(:feature_name)
    #   # use repository with Feature
    #
    class ActiveRecordRepository
      # Constructor
      #
      def initialize(model)
        @model = model
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        @model.where(active: true).map { |f| f.name.to_sym }
      end

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def add_active_feature(feature)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        @model.create!(name: feature.to_s, active: true)
      end

      # Checks if the given feature is a not symbol and raises an exception if so
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
        raise ArgumentError, "feature :#{feature} already added" if @model.exists?(name: feature.to_s)
      end
      private :check_feature_already_in_list
    end
  end
end
