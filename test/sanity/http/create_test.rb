# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Create do
  let(:klass) { Sanity::Http::Create }
  subject { klass.new(params: {}, resource_klass: "") }

  it { assert_equal "create", subject.body_key }
end
