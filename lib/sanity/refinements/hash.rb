# frozen_string_literal: true

module Sanity
  module Refinements
    module Hash
      refine Hash do
        # Defined in Ruby >= 3
        def except!(*keys)
          keys.each { |key| delete(key) }
          self
        end

        # Defined in Ruby >= 3
        def except(*keys)
          dup.except!(*keys)
        end
      end
    end
  end
end
