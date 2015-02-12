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
    old_features, old_auto_refresh, old_perform_initial_refresh =
        @active_features.dup, @auto_refresh, @perform_initial_refresh
    @active_features.concat(features).uniq!
    @auto_refresh, @perform_initial_refresh = false, false
    yield
  ensure
    @active_features, @auto_refresh, @perform_initial_refresh =
        old_features, old_auto_refresh, old_perform_initial_refresh
  end

  # Execute the code block with the given features deactive
  #
  # Example usage:
  #   Feature.run_with_deactivated(:feature, :another_feature) do
  #     # your test code here
  #   end
  def self.run_with_deactivated(*features)
    old_features, old_auto_refresh, old_perform_initial_refresh =
        @active_features.dup, @auto_refresh, @perform_initial_refresh
    @active_features -= features
    @auto_refresh, @perform_initial_refresh = false, false
    yield
  ensure
    @active_features, @auto_refresh, @perform_initial_refresh =
        old_features, old_auto_refresh, old_perform_initial_refresh
  end
end
