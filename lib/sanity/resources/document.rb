# frozen_string_literal: true

module Sanity
  class Document < Sanity::Resource
    mutatable
    queryable
    attribute :_id, default: ""
    attribute :_type, default: ""
   end
end
