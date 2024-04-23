# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Unpublish do
  let(:klass) { Sanity::Http::Unpublish }
  subject { klass.new(params: {}, resource_klass: "") }

  it { assert_equal "documentId", subject.body_key }
end
