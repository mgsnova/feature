module Feature
  module Repository
    # RedisRepository for active feature list
    #
    # Example usage:
    #   repository = RedisRepository.new("feature_toggles")
    #   repository.create(:feature_name)
    #
    # 'feature_toggles' can be whatever name you want to use for
    # the Redis hash that will store all of your feature toggles.
    #
    class RedisRepository
      attr_writer :redis

      # Constructor
      #
      # @param redis_key the key of the redis hash where all the toggles will be stored
      #
      def initialize(redis_key, client = nil)
        @redis_key = redis_key
        @redis = client unless client.nil?
      end

      # Remove a feature from a repository
      #
      # @param [Symbol] feature the feature to be removed
      #
      def destroy(feature)
        redis.hdel(@redis_key, feature.to_s) == 1
      end

      # Get the value of feature from a repository
      #
      # @param [Symbol] feature the feature to be checked
      # @return [Boolean] whether the feature is active
      def get(feature)
        convert_string_to_bool(redis.hget(@redis_key, feature.to_s))
      end

      # Add a feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def create(feature, val = false)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        set(feature, val)
      end

      # Set the value of feature in a repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def set(feature, val)
        redis.hset(@redis_key, feature.to_s, val)
        true
      end

      # List all of the features in a repository
      #
      # @return [Array<Symbol>] list of all features
      #
      def features
        redis.hgetall(@redis_key).inject({}) { |h, (k, v)| h.merge(k.to_sym => convert_string_to_bool(v)) }
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        redis.hgetall(@redis_key).select { |_k, v| v.to_s == 'true' }.map { |k, _v| k.to_sym }
      end

      # Returns list of inactive features
      #
      # @return [Array<Symbol>] list of inactive features
      #
      def inactive_features
        redis.hgetall(@redis_key).select { |_k, v| v.to_s == 'false' }.map { |k, _v| k.to_sym }
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
        raise ArgumentError, "feature :#{feature} already added" if redis.hexists(@redis_key, feature)
      end
      private :check_feature_already_in_list

      # Converts "true" to true and "false" || nil to false
      #
      # @param [String] "true" or "false"
      def convert_string_to_bool(str)
        return true if str == 'true'
        return false if str.nil? || str == 'false'
        raise ArgumentError, "invalid bool string: #{str.inspect}"
      end
      private :convert_string_to_bool

      # Returns the currently specified redis client
      #
      # @return [Redis] Currently set redis client
      #
      def redis
        @redis ||= Redis.current
      end
      private :redis
    end
  end
end
