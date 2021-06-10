# frozen_string_literal: true

require "forwardable"

module Sanity
  module Delegator
    class << self
      def included(base)
        base.extend(Forwardable)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def delegate(*methods, to:)
        def_delegators to, *methods
      end
    end
  end
end
