module Feature
  module Repository
    ##
    # Abstract class for subclassing and building repository classes which
    # provide lists of active features
    #
    class AbstractRepository
      ##
      # Constructor
      #
      # Should be overridden in derived class to initialize repository with all data needed
      #
      def initialize
        raise "abstract class #{self.class.name}!"
      end

      ##
      # Returns list of active features
      #
      #   @return   Array<Symbol>
      #
      def active_features
        raise "#{__method__} has to be overridden in derived class"
      end
    end
  end
end
