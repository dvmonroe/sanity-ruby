# frozen_string_literal: true

require "time"

module Sanity
  # Attributable is responsible for setting the appropriate attributes
  # on an object in memory
  #
  # The attribute marco is used to define the available attributes and
  # the default return value if applicable
  #
  # @example provides getter and setter methods for `_id` and sets the default value to an empty string
  #   attribute :_id, default: ""
  #
  # @example provides ability to set a type (currently supports :boolean, :float, :intger, or :time)
  #   attribute :login_count, type: :integer
  #
  # @example provides getter and setter methods for both `_id` and the alias `id`
  #   attribute :_id, as: :id
  #
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

      def aliased_attributes
        @aliased_attributes ||= {}
      end

      def default_attributes
        @default_attributes ||= {}
      end

      private

      def attribute(name, default: nil, as: nil, type: nil)
        attributes.push(name)
        default_attributes[name] = default if default

        define_method("#{name}=") do |value|
          @attributes[name] =
            case type
            when :boolean
              value.to_s == "true"
            when :float
              value.to_f
            when :integer
              value.to_i
            when :time
              Time.parse(value.to_s)
            else
              value
            end
        end
        define_method(name.to_s) { @attributes[name] }

        if as
          aliased_attributes[as] = name
          alias_method("#{as}=", "#{name}=")
          alias_method(as, name)
        end
      end
    end

    attr_reader :attributes

    def initialize(**kwargs)
      @attributes ||= {}
      kwargs.each { |name, value| public_send("#{name}=", value) }
      self.class.default_attributes.each do |name, value|
        public_send("#{name}=", value) unless public_send(name)
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
