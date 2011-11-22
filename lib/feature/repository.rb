module Feature
  # Module for holding feature repositories
  module Repository
    require 'feature/repository/abstract_repository'
    require 'feature/repository/simple_repository'
    require 'feature/repository/yaml_repository'
  end
end
