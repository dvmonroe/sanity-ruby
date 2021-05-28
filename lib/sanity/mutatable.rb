# frozen_string_literal: true

module Sanity
  module Mutatable
    class << self
      def included(base)
        base.extend(ClassMethods)
      end
    end

    module ClassMethods
      DEFAULT_KLASS_MUTATIONS = %i(create create_or_replace create_if_missing).freeze
      DEFAULT_INSTANCE_MUTATIONS = %i(create_or_replace patch destroy).freeze
      ALL_MUTATIONS = DEFAULT_KLASS_MUTATIONS | DEFAULT_INSTANCE_MUTATIONS

      private

      def mutatable(**options)
        options.fetch(:only, ALL_MUTATIONS).each do |mutation|
          if DEFAULT_KLASS_MUTATIONS.include? mutation.to_sym
            define_singleton_method(mutation) do |**args|
              Module.const_get("Sanity::Http::#{mutation.to_s.classify}").call(**args.merge(resource_klass: self))
            end
          end

          if DEFAULT_INSTANCE_MUTATIONS.include? mutation.to_sym
            define_method(mutation) do |**attributes|
              Module.const_get("Sanity::Http::#{mutation.to_s.classify}").call(**attributes)
            end
          end
        end
      end
    end
  end
end
