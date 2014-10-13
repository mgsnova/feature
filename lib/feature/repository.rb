module Feature
  # Module for holding feature repositories
  module Repository
    require 'feature/repository/simple_repository'
    require 'feature/repository/yaml_repository'
    require 'feature/repository/active_record_repository'
    require 'feature/repository/redis_repository'
  end
end
