require 'feature'

# This file provides functionality for testing your code with features
# activated or deactivated.
# This file should only be required in test/spec code!
#
# To enable Feature testing capabilities do:
#   require 'feature/testing'
module Feature
  # Execute the code block with the given features active
  #
  # Example usage:
  #   Feature.run_with_activated(:feature, :another_feature) do
  #     # your test code here
  #   end
  def self.run_with_activated(*features, &blk)
    with_stashed_config do
      @active_features.concat(features).uniq!
      @auto_refresh = false
      @perform_initial_refresh = false
      blk.call
    end
  end

  # Execute the code block with the given features deactive
  #
  # Example usage:
  #   Feature.run_with_deactivated(:feature, :another_feature) do
  #     # your test code here
  #   end
  def self.run_with_deactivated(*features, &blk)
    with_stashed_config do
      @active_features -= features
      @auto_refresh = false
      @perform_initial_refresh = false
      blk.call
    end
  end

  # Execute the given code block and store + restore the feature
  # configuration before/after the execution
  def self.with_stashed_config
    @active_features = [] if @active_features.nil?
    old_features = @active_features.dup
    old_auto_refresh = @auto_refresh
    old_perform_initial_refresh = @perform_initial_refresh
    yield
  ensure
    @active_features = old_features
    @auto_refresh = old_auto_refresh
    @perform_initial_refresh = old_perform_initial_refresh
  end
end
