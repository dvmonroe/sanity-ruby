# frozen_string_literal: true

module Sanity
  module Http
    module Query
      class << self
        def included(base)
          base.extend(ClassMethods)
        end
      end

      module ClassMethods
        def call(*args)
          new(args).call
        end
      end

      # TODO: Update
      def initialize(*args)
      end

      # TODO: Update
      def call
        true
      end
    end
  end
end
