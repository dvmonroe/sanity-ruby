# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::CreateOrReplace do
  let(:klass) { Sanity::Http::CreateOrReplace }
  subject { klass.new(params: {}, resource_klass: "") }

  it { assert_equal "createOrReplace", subject.body_key }
end
