# Feature module provides all methods
# - to set a feature repository
# - to check if a feature (represented by a symbol) is active or inactive
# - for conditional block execution with or without a feature
# - to refresh the feature lists (request them from repository)
#
# @note all features not active will be handled has inactive
# 
# Example usage:
#   repository = SimpleRepository.new
#   repository.add_active_feature(:feature_name)
#
#   Feature.set_repository(repository)
#   Feature.active?(:feature_name)
#   # => true
#   Feature.inactive?(:inactive_feature)
#   # => false
#
#   Feature.with(:feature_name) do
#     # code will be executed
#   end
#
module Feature
  require 'feature/repository'

  @repository = nil
  @active_features = nil

  # Set the feature repository
  # The given repository has to respond to method 'active_features' with an array of symbols
  #
  # @param [Object] repository the repository to get the features from
  #
  def self.set_repository(repository)
    if !repository.respond_to?(:active_features)
      raise ArgumentError, "given repository does not respond to active_features"
    end

    @repository = repository
    refresh!
  end

  # Obtains list of active features from repository (for the case they change e.g. when using db-backed repository)
  #
  def self.refresh!
    @active_features = @repository.active_features
  end

  ##
  # Requests if feature is active
  #
  # @param [Symbol] feature
  # @return [Boolean]
  #
  def self.active?(feature)
    if !@repository
      raise "Feature is missing Repository for obtaining feature lists"
    end

    @active_features.include?(feature)
  end

  # Requests if feature is inactive (or unknown)
  #
  # @param [Symbol] feature
  # @return [Boolean]
  #
  def self.inactive?(feature)
    !self.active?(feature)
  end

  # Execute the given block if feature is active
  #
  # @param [Symbol] feature
  #
  def self.with(feature)
    if !block_given?
      raise ArgumentError, "no block given to #{__method__}"
    end

    if active?(feature)
      yield
    end
  end

  # Execute the given block if feature is inactive
  #
  # @param [Symbol] feature
  #
  def self.without(feature)
    if !block_given?
      raise ArgumentError, "no block given to #{__method__}"
    end

    if inactive?(feature)
      yield
    end
  end
end
