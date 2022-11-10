# frozen_string_literal: true
require 'time'

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
  #   attribute :_id, alias: :id
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

      private

      def attribute(name, default: nil, alias: nil, type: nil)
        attributes.push(name)

        self.define_method("#{name}=") do |value|
          @attributes[name] =
            case type
            when :boolean
              value.to_s == 'true'
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
        self.define_method("#{name}") { @attributes[name] }

        alias_name = binding.local_variable_get('alias')
        if alias_name
          aliased_attributes[alias_name] = name
          self.alias_method("#{alias_name}=", "#{name}=")
          self.alias_method(alias_name, name)
        end
      end

    end

    attr_reader :attributes

    def initialize(**kwargs)
      @attributes ||= {}
      kwargs.each { |name, value| public_send("#{name}=", value) }
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
