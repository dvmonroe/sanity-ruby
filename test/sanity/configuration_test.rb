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

  describe "thread safety" do
    it "maintains separate configurations across threads" do
      threads = []
      configurations = []

      4.times do |i|
        threads << Thread.new do
          Sanity.configure do |config|
            config.project_id = "Project#{i}"
            config.dataset = "Dataset#{i}"
            config.api_version = "v#{i}"
            config.token = "Token#{i}"
            config.use_cdn = i.even?
          end

          configurations << {
            index: i,
            project_id: Sanity.configuration.project_id,
            dataset: Sanity.configuration.dataset,
            api_version: Sanity.configuration.api_version,
            token: Sanity.configuration.token,
            use_cdn: Sanity.configuration.use_cdn
          }
        end
      end

      threads.each(&:join)

      configurations.sort_by { |config| config[:index] }.each_with_index do |config, i|
        assert_equal "Project#{i}", config[:project_id]
        assert_equal "Dataset#{i}", config[:dataset]
        assert_equal "v#{i}", config[:api_version]
        assert_equal "Token#{i}", config[:token]
        assert_equal i.even?, config[:use_cdn]
      end
    end
  end
end
