# frozen_string_literal: true

require "test_helper"

using Sanity::Refinements::Strings

describe Sanity::Refinements::Strings do
  it { assert_equal "foobar", "foobar".camelize_lower }
  it { assert_equal "fooBar", "foo_bar".camelize_lower }
  it { assert_equal "fooBarBaz", "foo_bar_baz".camelize_lower }

  it { assert_equal "Foobar", "foobar".classify }
  it { assert_equal "FooBarBaz", "foo_bar_baz".classify }

  it { assert_equal "Bar", "Foo::Bar".demodulize }
  it { assert_equal "Baz", "Foo::Bar::Baz".demodulize }

  it { assert_equal "foo_bar", "FooBar".underscore }
  it { assert_equal "foo", "Foo".underscore }
end
