# frozen_string_literal: true

module Sanity
  class Resource
    include Sanity::Attributable
    include Sanity::Mutatable
    include Sanity::Queryable
  end
end
