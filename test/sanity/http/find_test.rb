# frozen_string_literal: true

require "test_helper"

describe Sanity::Http::Find do
  let(:klass) { Sanity::Http::Find }

  it do
    assert_equal klass.new(id: 'test_123').id, 'test_123'
  end
end
