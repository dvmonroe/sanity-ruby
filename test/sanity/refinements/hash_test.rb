# frozen_string_literal: true

require "test_helper"

using Sanity::Refinements::Hashes

describe Sanity::Refinements::Hashes do
  it { assert_equal({foo: :bar}, {foo: :bar, baz: :boom}.except(:baz)) }
end
