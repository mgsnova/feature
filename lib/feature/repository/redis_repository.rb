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
      attr_writer :redis

      # Constructor
      #
      # @param redis_key the key of the redis hash where all the toggles will be stored
      #
      def initialize(redis_key, client = nil)
        @redis_key = redis_key
        @redis = client unless client.nil?
      end

      # Returns list of active features
      #
      # @return [Array<Symbol>] list of active features
      #
      def active_features
        redis.hgetall(@redis_key).select { |_k, v| v.to_s == 'true' }.map { |k, _v| k.to_sym }
      end

      # Add an active feature to repository
      #
      # @param [Symbol] feature the feature to be added
      #
      def add_active_feature(feature)
        check_feature_is_not_symbol(feature)
        check_feature_already_in_list(feature)
        redis.hset(@redis_key, feature, true)
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
