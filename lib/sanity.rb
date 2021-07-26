# frozen_string_literal: true

require "forwardable"
require "sanity/refinements"

require "sanity/version"
require "sanity/configuration"

require "sanity/groqify"
require "sanity/http"

require "sanity/attributable"
require "sanity/mutatable"
require "sanity/queryable"

require "sanity/resource"
require "sanity/resources"

module Sanity
  class Error < StandardError; end
end
