# frozen_string_literal: true

require "sanity/groq/filter"
require "sanity/groq/order"
require "sanity/groq/slice"
require "sanity/groq/select"

module Sanity
  class Groqify
    class << self
      def call(**args)
        new(**args).call
      end
    end

    RESERVED = Sanity::Groq::Filter::RESERVED |
      Sanity::Groq::Slice::RESERVED |
      Sanity::Groq::Order::RESERVED |
      Sanity::Groq::Select::RESERVED

    attr_reader :args, :query

    def initialize(**args)
      @args = args
      @query = +""
    end

    def call
      "*[#{filter}]#{order}#{slice}#{select}"
    end

    private

    def order
      Sanity::Groq::Order.call(**args)
    end

    def select
      Sanity::Groq::Select.call(**args)
    end

    def slice
      Sanity::Groq::Slice.call(**args)
    end

    def filter
      Sanity::Groq::Filter.call(**args)
    end
  end
end
