# frozen_string_literal: true

require "active_support/core_ext/string/inflections"
require "active_support/core_ext/array/wrap"

require "sanity/version"
require "sanity/configuration"
require "sanity/delegator"

require "sanity/http"

require "sanity/attributable"
require "sanity/mutatable"
require "sanity/queryable"

require "sanity/resource"
require "sanity/resources"

module Sanity
  class Error < StandardError; end
end
