# Set repository to ActiveRecord
if <%= class_name %>.table_exists?
  repo = Feature::Repository::ActiveRecordRepository.new(<%= class_name %>)
  Feature.set_repository(repo)
end
