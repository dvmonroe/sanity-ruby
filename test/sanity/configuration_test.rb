# frozen_string_literal: true

require "test_helper"

describe Sanity::Configuration do
  subject { Sanity::Configuration.new }

  it { assert_equal "", subject.project_id }
  it { assert_equal "", subject.dataset }
  it { assert_equal "", subject.api_version }
  it { assert_equal "", subject.token }
  it { refute subject.use_cdn }

  describe "#api_subdomain" do
    context "when use_cdn is false" do
      it { assert_equal "api", subject.api_subdomain }
    end

    context "when use_cdn is true" do
      before { subject.stubs(use_cdn: true) }
      it { assert_equal "apicdn", subject.api_subdomain }
    end
  end
end
