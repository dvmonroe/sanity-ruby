# frozen_string_literal: true

module Sanity
  module Refinements
    # String refinements based on ActiveSupport methods.
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
    module Strings
      refine String do
        def camelize_lower
          split("_")[0..].each_with_index.map do |val, idx|
            idx != 0 ? val.capitalize : val
          end.join
        end

        def classify
          split("_").map(&:capitalize).join
        end

        def demodulize
          split("::")[-1]
        end

        def underscore
          split(/(?=[A-Z])/).map(&:downcase).join("_")
        end
      end
    end
  end
end
