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

      START_PAREN = "("
      END_PAREN = ")"

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

      def filter(key: nil)
        key ? " #{multi_filter(key)}" : default_multi_filter.to_s
      end

      def iterate(arg = args, nested_key: nil)
        arg.each do |key, val|
          if val.is_a?(String) || val.is_a?(Integer)
            filter_value << "#{filter(key: nested_key)} #{key} #{equal} #{cast_value(val)}"
          elsif val.is_a?(Array) && !val[0].is_a?(Hash)
            filter_value << "#{key} in #{val.map(&:to_s)}"
          elsif [true, false].include?(val)
            filter_value << "#{filter(key: nested_key)} #{key} #{equal} #{val}"
          elsif LOGICAL_OPERATORS.key?(key)
            if val.is_a?(Array)
              val.each { |hsh| iterate(hsh, nested_key: key) }
            elsif LOGICAL_OPERATORS.key?(val.keys[0])
              filter_value << " #{LOGICAL_OPERATORS[key]} #{START_PAREN}"

              val.values[0].each_with_index do |(vkey, vval), idx|
                operator = logical_operator(val.keys[0], index: idx)
                filter_value << "#{operator} " unless operator.empty?

                if vkey.is_a?(Hash)
                  vkey.each do |vvkey, vvval|
                    filter_value << "#{vvkey} #{equal} #{cast_value(vvval)}"
                  end
                else
                  filter_value << "#{vkey} #{equal} #{cast_value(vval)}"
                end
              end

              filter_value << END_PAREN
            else
              iterate(val, nested_key: key)
            end
          elsif COMPARISON_OPERATORS.key?(val.keys[0])
            val.each do |vkey, vval|
              filter_value << "#{filter(key: nested_key)} #{key} #{COMPARISON_OPERATORS[vkey]} #{cast_value(vval)}"
            end
          end
        end
      end

      def logical_operator(key, index: 0)
        index.positive? ? " #{LOGICAL_OPERATORS[key]}" : ""
      end

      def multi_filter(key)
        filter_value.length.positive? ? LOGICAL_OPERATORS[key] : ""
      end
    end
  end
end
