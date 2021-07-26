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

      attr_reader :order, :val

      def initialize(**args)
        args.slice(*RESERVED).then do |opts|
          @order = opts[:order]
        end

        @val = +""
      end

      def call
        return unless order

        raise ArgumentError, "order must be hash" unless order.is_a?(Hash)

        order.to_a.each_with_index do |(key, sort), idx|
          val << " | order(#{key} #{sort})".then do |str|
            idx.positive? ? str : str.strip
          end
        end

        val
      end
    end
  end
end
