namespace :feature do
  namespace :redis do
    task list: :environment do
      check_repository_is_not_redis
      puts "Feature toggles stored under Redis key '#{redis_key}':"
      puts Redis.current.hgetall(redis_key)
    end

    task list_active: :environment do
      check_repository_is_not_redis
      puts "Active feature toggles stored under Redis key '#{redis_key}':"
      puts Feature.repository.active_features
    end

    task :activate, [:name] => :environment do |_t, args|
      check_repository_is_not_redis
      if args[:name]
        Feature.repository.activate_feature(args[:name])
        puts "Activated feature: #{args[:name]}"
      else
        puts 'Usage: rake toggles:activate[feature_name]'
      end
    end

    task :deactivate, [:name] => :environment do |_t, args|
      check_repository_is_not_redis
      if args[:name]
        Feature.repository.deactivate_feature(args[:name])
        puts "Deactivated feature: #{args[:name]}"
      else
        puts 'Usage: rake toggles:deactivate[feature_name]'
      end
    end

    task :remove, [:name] => :environment do |_t, args|
      check_repository_is_not_redis
      if args[:name]
        Feature.repository.remove_feature(args[:name]) if args[:name]
        puts "Removed feature: #{args[:name]}"
      else
        puts 'Usage: rake toggles:remove[feature_name]'
      end
    end

    task :add, [:name] => :environment do |_t, args|
      check_repository_is_not_redis
      if args[:name]
        Feature.repository.add_inactive_feature(args[:name]) if args[:name]
        puts "Added new (inactive) feature: #{args[:name]}"
      else
        puts 'Usage: rake toggles:add[feature_name]'
      end
    end

    def redis_key
      check_repository_is_not_redis
      Feature.repository.redis_key
    end

    def check_repository_is_not_redis
      fail Error, 'RedisRepository not initialized for this application' unless using_redis?
    end

    def using_redis?
      Feature.repository.class == Feature::Repository::RedisRepository
    end
  end
end
