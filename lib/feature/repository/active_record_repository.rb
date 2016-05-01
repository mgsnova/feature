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
        feature_obj = @model.find_by_name(feature.to_s)
        feature_obj.destroy! if feature_obj.present?
      end

      # Get the value of feature from a repository
      #
      # @param [Symbol] feature the feature to be checked
      # @return [Boolean] whether the feature is active
      def get_feature(feature)
        check_feature_is_not_symbol(feature)
        @model.find_by_name(feature.to_s).active
      end

      # Add a feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def create_feature(feature, val)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        @model.create!({ name: feature.to_s, active: val }, without_protection: :true)
      end

      # Set the value of feature in a repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def set_feature(feature, val)
        feature_obj = @model.find_by_name(feature.to_s)
        return create_feature(feature, val) if feature_obj.nil?
        feature_obj.active = val
        feature_obj.save!
      end

      # List all of the features in a repository
      #
      # @return [Array<Symbol>] list of all features
      #
      def features
        @model.all.inject({}) { |a, e| a.merge(e.name.to_sym => e.active) }
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        @model.where(active: true).map { |f| f.name.to_sym }
      end

      # Returns list of inactive features
      #
      # @return [Array<Symbol>] list of inactive features
      #
      def inactive_features
        @model.where(active: false).map { |f| f.name.to_sym }
      end

      # Checks if the given feature is a not symbol and raises an exception if so
      #
      # @param [Sybmol] feature the feature to be checked
      #
      def check_feature_is_not_symbol(feature)
        raise ArgumentError, "#{feature} is not a symbol" unless feature.instance_of?(Symbol)
      end
      private :check_feature_is_not_symbol

      # Checks if given feature is already added to list of all features
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
