# frozen_string_literal: true

module Sanity
  module Groq
    class Order
      class << self
        def call(**args)
          new(**args).call
        end
      end

      RESERVED = %i[order]

      attr_reader :args

      def initialize(**args)
        @args = args
      end

      def call
        ""
        # opts = args.except(*RESERVED - ORDERING_RESERVED)

        # if opts.include?(:order)
        #   "| order()"
        # end
      end
    end
  end
end
