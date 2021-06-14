# frozen_string_literal: true

require "test_helper"

using Sanity::Refinements::Arrays

describe Sanity::Refinements::Arrays do
  it { assert_equal [{}], Array.wrap({}) }
  it { assert_equal [], Array.wrap([]) }
  it { assert_equal [], Array.wrap(nil) }
  it { assert_equal [{foo: {}}], Array.wrap({foo: {}}) }
  it { assert_equal [[], []], Array.wrap([[], []]) }
end
