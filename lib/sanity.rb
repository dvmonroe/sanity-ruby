# frozen_string_literal: true

require "active_model"
require "forwardable"
require "sanity/refinements"

require "sanity/version"
require "sanity/configuration"

require "sanity/groqify"
require "sanity/http"
require "sanity/helpers"

require "sanity/mutatable"
require "sanity/queryable"
require "sanity/serializable"

require "sanity/resource"
require "sanity/resources"

module Sanity
  class Error < StandardError; end

  RESULT_WRAPPER_DEPRECATION_WARNING = "DEPRECATION: `result_wrapper` is deprecated. Please use `serializer` instead."
end
