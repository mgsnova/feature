namespace :feature do
  namespace :redis do
    task list: :environment do
      exit_if_not_using_redis
      puts "Feature toggles stored under Redis key '#{redis_key}':"
      puts Redis.current.hgetall(redis_key)
    end

    task :enable, [:name] => :environment do |_t, args|
      exit_if_not_using_redis
      if args[:name]
        enable_toggle(args[:name])
      else
        puts 'Usage: rake toggles:enable[toggle_name]'
      end
    end

    task :disable, [:name] => :environment do |_t, args|
      exit_if_not_using_redis
      if args[:name]
        disable_toggle(args[:name])
      else
        puts 'Usage: rake toggles:disable[toggle_name]'
      end
    end

    task :delete, [:name] => :environment do |_t, args|
      exit_if_not_using_redis
      if args[:name]
        delete_toggle(args[:name]) if args[:name]
      else
        puts 'Usage: rake toggles:delete[toggle_name]'
      end
    end

    task :create, [:name] => :environment do |_t, args|
      exit_if_not_using_redis
      if args[:name]
        create_toggle(args[:name]) if args[:name]
      else
        puts 'Usage: rake toggles:create[toggle_name]'
      end
    end

    def redis_key
      exit_if_not_using_redis
      Feature.repository.redis_key
    end

    def exit_if_not_using_redis
      STDERR.puts 'RedisRepository not initialized for this application' unless using_redis?
      exit 1 unless using_redis?
    end

    def using_redis?
      Feature.repository.class == Feature::Repository::RedisRepository
    end

    def create_toggle(toggle_name)
      if Redis.current.hexists(redis_key, toggle_name.to_s)
        puts "Couldn't create toggle because it already exists: #{toggle_name}"
      else
        Redis.current.hset(redis_key, toggle_name.to_s, 'false')
        puts "Created toggle and set it to false: #{toggle_name}"
      end
    end

    def delete_toggle(toggle_name)
      if Redis.current.hexists(redis_key, toggle_name.to_s)
        Redis.current.hdel(redis_key, toggle_name.to_s)
        puts "Deleted toggle: #{toggle_name}"
      else
        puts "Couldn't delete toggle because it doesn't exist: #{toggle_name}"
      end
    end

    def disable_toggle(toggle_name)
      if Redis.current.hexists(redis_key, toggle_name.to_s)
        Redis.current.hset(redis_key, toggle_name.to_s, 'false')
        puts "Set toggle to false: #{toggle_name}"
      else
        puts "Couldn't disable toggle because it doesn't exist: #{toggle_name}"
      end
    end

    def enable_toggle(toggle_name)
      if Redis.current.hexists(redis_key, toggle_name.to_s)
        Redis.current.hset(redis_key, toggle_name.to_s, 'true')
        puts "Set toggle to true: #{toggle_name}"
      else
        puts "Couldn't enable toggle because it doesn't exist: #{toggle_name}"
      end
    end
  end
end
