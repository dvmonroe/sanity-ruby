# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Delete do
  let(:klass) { Sanity::Http::Delete }
  subject { klass.new(params: {}, resource_klass: "") }

  it { assert_equal "delete", subject.body_key }
end
