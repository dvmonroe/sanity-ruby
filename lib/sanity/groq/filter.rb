# frozen_string_literal: true

# Hash#except! was added in Ruby 3
using Sanity::Refinements::Hashes if RUBY_VERSION.to_i < 3.0

module Sanity
  module Groq
    class Filter
      class << self
        def call(**args)
          new(**args).call
        end
      end

      COMPARISON_OPERATORS = {
        is: "==",
        not: "!=",
        gt: ">",
        gt_eq: ">=",
        lt: "<",
        lt_eq: "<=",
        match: "match"
      }

      LOGICAL_OPERATORS = {
        and: "&&",
        or: "||"
      }

      RESERVED = COMPARISON_OPERATORS.keys | LOGICAL_OPERATORS.keys

      attr_reader :args, :filter_value

      def initialize(**args)
        @args = args.except(*Sanity::Groqify::RESERVED - RESERVED)
        @filter_value = +""
      end

      def call
        iterate
        filter_value.strip
      end

      private

      def cast_value(val)
        val.is_a?(Integer) ? val : "'#{val}'"
      end

      def default_multi_filter
        filter_value.length.positive? ? " #{LOGICAL_OPERATORS[:and]}" : ""
      end

      def equal
        COMPARISON_OPERATORS[:is]
      end

      def iterate
        args.each do |key, val|
          if val.is_a?(String)
            filter_value << "#{default_multi_filter} #{key} #{equal} #{cast_value(val)}"
          elsif val.is_a?(Array)
            filter_value << "#{key} in #{val.map(&:to_s)}"
          elsif LOGICAL_OPERATORS.key?(key)
            if LOGICAL_OPERATORS.key?(val.keys[0])
              filter_value << " #{LOGICAL_OPERATORS[key]} ("

              val.values[0].each_with_index do |(vkey, vval), idx|
                filter_value << if idx.positive?
                  " #{LOGICAL_OPERATORS[val.keys[0]]} #{vkey} #{equal} #{cast_value(vval)}"
                else
                  "#{vkey} #{equal} #{cast_value(vval)}"
                end
              end
              filter_value << ")"
            else
              val.each do |vkey, vval|
                filter_value << " #{multi_filter(key)} #{vkey} #{equal} #{cast_value(vval)}"
              end
            end
          elsif COMPARISON_OPERATORS.key?(val.keys[0])
            val.each do |vkey, vval|
              filter_value << "#{default_multi_filter} #{key} #{COMPARISON_OPERATORS[vkey]} #{cast_value(vval)}"
            end
          end
        end
      end

      def multi_filter(key)
        filter_value.length.positive? ? LOGICAL_OPERATORS[key] : ""
      end
    end
  end
end
