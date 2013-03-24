require 'feature'

# This file provides functionality for testing your code with features
# activated or deactivated.
# This file should only be required in test/spec code!
#
# To enable Feature testing capabilities do:
#   require 'feature/testing'
module Feature
  # Execute the code block with the given feature active
  # 
  # Example usage:
  #   Feature.run_with_activated(:feature) do
  #     # your test code here
  #   end
  def self.run_with_activated(feature)
    old_features = @active_features.dup
    @active_features.push(feature).uniq!
    yield
  ensure
    @active_features = old_features
  end

  # Execute the code block with the given feature deactive
  # 
  # Example usage:
  #   Feature.run_with_deactivated(:feature) do
  #     # your test code here
  #   end
  def self.run_with_deactivated(feature)
    old_features = @active_features.dup
    @active_features.delete(feature)
    yield
  ensure
    @active_features = old_features
  end
end
