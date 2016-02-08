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
  require 'feature/generators/install_generator'

  @repository = nil
  @active_features = nil

  # Set the feature repository
  # The given repository has to respond to method 'active_features' with an array of symbols
  #
  # @param [Object] repository the repository to get the features from
  # @param [Boolean] auto_refresh optional (default: false) - refresh feature toggles on every check if set true
  # @param [Integer] timeout optional (default: nil) - does a refresh after timeout seconds
  #
  def self.set_repository(repository, auto_refresh = false, timeout = nil)
    unless repository.respond_to?(:active_features)
      fail ArgumentError, 'given repository does not respond to active_features'
    end

    @auto_refresh = auto_refresh
    @perform_initial_refresh = true
    @repository = repository
    @timeout = timeout
    @last_refresh = Time.now
  end

  # Refreshes list of active features from repository.
  # Useful when using an repository with external source.
  #
  def self.refresh!
    @active_features = @repository.active_features
    @last_refresh = Time.now if !!@timeout
    @perform_initial_refresh = false
  end

  # returns true if refresh is due because of timeout set
  #
  def self.timeout_refresh?
    !!@timeout && (Time.now - @last_refresh) > @timeout
  end

  ##
  # Requests if feature is active
  #
  # @param [Symbol] feature
  # @return [Boolean]
  #
  def self.active?(feature)
    fail 'missing Repository for obtaining feature lists' unless @repository

    refresh! if @auto_refresh || @perform_initial_refresh || require_refresh?

    @active_features.include?(feature)
  end

  # Requests if feature is inactive (or unknown)
  #
  # @param [Symbol] feature
  # @return [Boolean]
  #
  def self.inactive?(feature)
    !active?(feature)
  end

  # Execute the given block if feature is active
  #
  # @param [Symbol] feature
  #
  def self.with(feature)
    fail ArgumentError, "no block given to #{__method__}" unless block_given?

    yield if active?(feature)
  end

  # Execute the given block if feature is inactive
  #
  # @param [Symbol] feature
  #
  def self.without(feature)
    fail ArgumentError, "no block given to #{__method__}" unless block_given?

    yield if inactive?(feature)
  end

  # Return value or execute Proc/lambda depending on Feature status.
  #
  # @param [Symbol] feature
  # @param [Object] value / lambda to use if feature is active
  # @param [Object] value / lambda to use if feature is inactive
  #
  def self.switch(feature, l1, l2)
    if active?(feature)
      l1.instance_of?(Proc) ? l1.call : l1
    else
      l2.instance_of?(Proc) ? l2.call : l2
    end
  end
end
