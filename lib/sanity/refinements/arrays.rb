# frozen_string_literal: true

module Sanity
  module Refinements
    # Array refinements based on ActiveSupport methods.
    #
    # Using refinements as to:
    #   1) not pollute the global namespace
    #   2) not conflict with ActiveSupport in a Rails based project
    #
    # These methods are defined in the way as needed in this gem. They
    # are not meant to replace the more robust ActiveSupport methods.
    #
    # Defining these here, removes the need for adding ActiveSupport
    # as a dependency
    module Arrays
      refine Array.singleton_class do
        def wrap(object)
          if object.nil?
            []
          elsif object.respond_to?(:to_ary)
            object.to_ary || [object]
          else
            [object]
          end
        end
      end
    end
  end
end
