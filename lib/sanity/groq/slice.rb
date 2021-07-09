# frozen_string_literal: true

module Sanity
  module Groq
    class Slice
      class << self
        def call(**args)
          new(**args).call
        end
      end

      RESERVED = %i[limit offset]

      attr_reader :args

      def initialize(**args)
        @args = args
      end

      def call
        opts = args.except(*Sanity::Groqify::RESERVED - RESERVED)

        if opts.key?(:limit)
          if !opts.key?(:offset)
            "[0...#{opts[:limit]}]"
          else
            "[#{opts[:offset]}...#{opts[:limit] + opts[:offset]}]"
          end
        end
      end
    end
  end
end
