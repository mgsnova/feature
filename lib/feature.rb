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
  # Only load the generator if Rails is defined and Version is greater than 3
  require 'feature/generators/install_generator' if defined?(Rails) && Rails::VERSION::STRING > '3'

  @repository = nil
  @active_features = nil

  # Set the feature repository
  # The given repository has to respond to method 'active_features' with an array of symbols
  #
  # @param [Object] repository the repository to get the features from
  #
  def self.set_repository(repository)
    unless repository.respond_to?(:active_features)
      fail ArgumentError, 'given repository does not respond to active_features'
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
    unless @repository
      fail 'Feature is missing Repository for obtaining feature lists'
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
    unless block_given?
      fail ArgumentError, "no block given to #{__method__}"
    end

    yield if active?(feature)
  end

  # Execute the given block if feature is inactive
  #
  # @param [Symbol] feature
  #
  def self.without(feature)
    unless block_given?
      fail ArgumentError, "no block given to #{__method__}"
    end

    yield if inactive?(feature)
  end

  # Return value or execute Proc/lambda depending on Feature status.
  #
  # @param [Symbol] feature
  # @param [Object] value to be returned / lambda to be evaluated if feature is active
  # @param [Object] value to be returned / lambda to be evaluated if feature is inactive
  #
  def self.switch(feature, l1, l2)
    if active?(feature)
      l1.is_a?(Proc) ? l1.call : l1
    else
      l2.is_a?(Proc) ? l2.call : l2
    end
  end
end
