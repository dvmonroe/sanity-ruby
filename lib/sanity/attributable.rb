# frozen_string_literal: true

require "pry"

module Sanity
  module Attributable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      def attributes
        @attributes ||= []
      end

      def default_attributes
        @defaults ||= {}
      end

      private

      def attribute(name, default: nil)
        attributes << name
        default_attributes.merge!("#{name}": default)
      end
    end

    attr_reader :attributes

    def initialize(**args)
      self.class.default_attributes.merge(args).then do |attrs|
        attrs.each do |key, val|

          define_singleton_method("#{key}=") do |val| 
            args[key] = val
            attributes[key] = val
          end

          define_singleton_method(key) { args[key] }
        end

        instance_variable_set("@attributes", attrs)
      end
    end

    def inspect
      attributes.keys.map { |key| "#{key}: #{attributes[key].inspect}" }.join(", ").then do |attrs|
        attrs.empty? ? "#<#{_instance}>" : "#<#{_instance} #{attrs}>"
      end
    end

    private

    def _instance
      "#{self.class}:0x#{object_id}"
    end
  end
end
