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
  def self.run_with_activated(*features)
    @active_features = [] if @active_features.nil?
    old_features = @active_features.dup
    old_auto_refresh = @auto_refresh
    @active_features.concat(features).uniq!
    @auto_refresh = false
    yield
  ensure
    @active_features = old_features
    @auto_refresh = old_auto_refresh
  end

  # Execute the code block with the given features deactive
  #
  # Example usage:
  #   Feature.run_with_deactivated(:feature, :another_feature) do
  #     # your test code here
  #   end
  def self.run_with_deactivated(*features)
    @active_features = [] if @active_features.nil?
    old_features = @active_features.dup
    old_auto_refresh = @auto_refresh
    @active_features -= features
    @auto_refresh = false
    yield
  ensure
    @active_features = old_features
    @auto_refresh = old_auto_refresh
  end
end
