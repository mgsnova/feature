module Feature
  module Repository
    # RedisRepository for active feature list
    #
    # Example usage:
    #   repository = RedisRepository.new("feature_toggles")
    #   repository.add_active_feature(:feature_name)
    #
    # 'feature_toggles' can be whatever name you want to use for
    # the Redis hash that will store all of your feature toggles.
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
        Redis.current.hgetall(@redis_key).select { |_k, v| v.to_s == 'true' }.map { |k, _v| k.to_sym }
      end

      # Returns list of all defined features (whether active or inactive)
      #
      # @return [Array<Symbol>] list of all defined features
      #
      def all_features
        Redis.current.hgetall(@redis_key)
      end

      # Returns the Redis hash key used to store the feature toggle data
      #
      # @return [String] the redis hash key
      attr_reader :redis_key

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added (param will be coerced into a Symbol using to_sym)
      #
      def add_active_feature(feature)
        check_feature_already_in_list(feature)
        Redis.current.hset(@redis_key, feature.to_sym, true)
      end

      # Add an inactive feature to repository
      #
      # @param [Symbol] feature the feature to be added (param will be coerced into a Symbol using to_sym)
      #
      def add_inactive_feature(feature)
        check_feature_already_in_list(feature)
        Redis.current.hset(@redis_key, feature.to_sym, false)
      end

      # Remove a feature from the repository
      #
      # @param [Symbol] feature the feature to remove (param will be coerced into a Symbol using to_sym)
      #
      def remove_feature(feature)
        check_feature_not_in_list(feature)
        Redis.current.hdel(@redis_key, feature.to_sym)
      end

      # Deactivate a feature in the repository
      #
      # @param [Symbol] feature the feature to deactivate
      #
      def deactivate_feature(feature)
        check_feature_not_in_list(feature)
        Redis.current.hset(@redis_key, feature.to_sym, false)
      end

      # Activate a feature in the repository
      #
      # @param [Symbol] feature the feature to activate
      #
      def activate_feature(feature)
        check_feature_not_in_list(feature)
        Redis.current.hset(redis_key, feature.to_sym, true)
      end

      # Checks if given feature is already added to list of active features
      # and raises an exception if so
      #
      # @param [Symbol] feature the feature to be checked
      #
      def check_feature_already_in_list(feature)
        fail ArgumentError, "feature :#{feature.to_sym} already added" if
          Redis.current.hexists(@redis_key, feature.to_sym)
      end
      private :check_feature_already_in_list

      # Checks if given feature is not already in the list of active features
      # and raises an exception if not
      #
      # @param [Symbol] feature the feature to be checked
      #
      def check_feature_not_in_list(feature)
        fail ArgumentError, "feature :#{feature.to_sym} doesn't exist" unless
          Redis.current.hexists(@redis_key, feature.to_sym)
      end
      private :check_feature_not_in_list
    end
  end
end
