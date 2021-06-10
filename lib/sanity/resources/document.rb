# frozen_string_literal: true

module Sanity
  # Sanity::Document is the core resource for interacting
  # with Sanity's HTTP API. This class provides out of
  # the box query and mutation methods for interacting
  # with the API.
  #
  # @example create a new document object in memory
  #   Sanity::Document.new(_id: 1, _type: "post")
  #
  # @example invoke the api operations to create a document
  #   Sanity::Document.create(params: {_type: "post", title: "A new blog post"})
  #
  # @example invoke the api operations to delete a document
  #   Sanity::Document.delete(params: {id: "1234"})
  #
  class Document < Sanity::Resource
    attribute :_id, default: ""
    attribute :_type, default: ""
    # See https://www.sanity.io/docs/http-mutations#ac77879076d4
    mutatable api_endpoint: "data/mutate/"
    queryable
   end
end
