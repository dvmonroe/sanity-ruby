# frozen_string_literal: true

require "sanity/http/mutation"
require "sanity/http/query"

require "sanity/http/create"
require "sanity/http/create_if_missing"
require "sanity/http/create_or_replace"
require "sanity/http/destroy"
require "sanity/http/patch"

require "sanity/http/find"
require "sanity/http/where"

module Sanity
  module Http
    class MissingParams < StandardError; end
    class MissingResource < StandardError; end
  end
end
