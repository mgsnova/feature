module Feature
  # Module for holding feature repositories
  module Repository
    autoload :SimpleRepository, 'feature/repository/simple_repository'
    autoload :YamlRepository, 'feature/repository/yaml_repository'
    autoload :ActiveRecordRepository, 'feature/repository/active_record_repository'
    autoload :RedisRepository, 'feature/repository/redis_repository'
  end
end
