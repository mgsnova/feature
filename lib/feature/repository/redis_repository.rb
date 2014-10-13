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
    class RedisRepository
      # Constructor
      #
      # @param redis_key the key of the redis hash where all the toggles will be stored
      #
      def initialize(redis_key)
        @redis_key = redis_key
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        Redis.current.hgetall(@redis_key).find_all { |k,v| v.to_s == "true" }.map { |k,v| k.to_sym }
      end

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def add_active_feature(feature)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        Redis.current.hset(@redis_key, feature, true)
      end

      # Checks that given feature is a symbol, raises exception otherwise
      #
      # @param [Sybmol] feature the feature to be checked
      #
      def check_feature_is_not_symbol(feature)
        fail ArgumentError, "#{feature} is not a symbol" unless feature.is_a?(Symbol)
      end
      private :check_feature_is_not_symbol

      # Checks if given feature is already added to list of active features
      # and raises an exception if so
      #
      # @param [Symbol] feature the feature to be checked
      #
      def check_feature_already_in_list(feature)
        fail ArgumentError, "feature :#{feature} already added" if Redis.current.hexists(@redis_key, feature)
      end
      private :check_feature_already_in_list
    end
  end
end
