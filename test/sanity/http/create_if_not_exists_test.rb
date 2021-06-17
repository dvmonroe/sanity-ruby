# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::CreateIfNotExists do
  let(:klass) { Sanity::Http::CreateIfNotExists }
  subject { klass.new(params: {}, resource_klass: "") }

  it { assert_equal "createIfNotExists", subject.body_key }
end
