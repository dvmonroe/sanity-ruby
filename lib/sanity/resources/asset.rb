# frozen_string_literal: true

module Sanity
  class Asset < Sanity::Resource
    mutatable only: %i(create), api_endpoint: "asset/images/"
  end
end
