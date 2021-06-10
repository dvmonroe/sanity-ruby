# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Mutation do
  let(:klass) { Sanity::Http::Mutation }

  it { assert_equal %i[sync async deferred], klass::ALLOWED_VISIBILITY }
  it { assert_equal "mutations", klass::REQUEST_KEY }

  it do
    assert_equal({return_ids: false, return_documents: false, visibility: :sync}, klass::QUERY_PARAMS)
  end
end
