# frozen_string_literal: true

module Sanity
  # Sanity::Resource is the base class used by
  # the sanity resources defined within this gem.
  #
  # Out of the box it includes the following mixins:
  #   Sanity::Attributable
  #   Sanity::Mutatable
  #   Sanity::Queryable
  #   Sanity::Serializable
  #
  # Sanity::Document and Sanity::Asset both inherit
  # from Sanity::Resource
  #
  # Any PORO in your project could become a
  # Sanity::Resource via inheritance
  #
  # @example inherit from Sanity::Resource
  #   class User < Sanity::Resource
  #     attribute :first_name, default: ""
  #     queryable
  #     mutatable
  #   end
  #
  class Resource
    include Sanity::Attributable
    include Sanity::Mutatable
    include Sanity::Queryable
    include Sanity::Serializable
  end
end
