# frozen_string_literal: true

module Sanity
  class Configuration
    # @return [String] Sanity's project id
    attr_accessor :project_id

    # @return [String] Sanity's dataset
    attr_accessor :dataset

    # @return [String] Sanity's api version
    attr_accessor :api_version

    # @return [String] Sanity's api token
    attr_accessor :token

    # @return [Boolean] whether to use Sanity's cdn api
    attr_accessor :use_cdn

    def initialize
      @project_id = ENV.fetch("SANITY_PROJECT_ID", "")
      @dataset = ENV.fetch("SANITY_DATASET", "")
      @api_version = ENV.fetch("SANITY_API_VERSION", "")
      @token = ENV.fetch("SANITY_TOKEN", "")
      @use_cdn = ENV.fetch("SANITY_USE_CDN", false) == "true"
    end

    # @return [String] Api subdomain based on use_cdn flag
    def api_subdomain
      use_cdn ? "apicdn" : "api"
    end
  end

  def self.configuration
    Thread.current[:sanity_configuration] ||= Configuration.new
  end

  class << self
    alias_method :config, :configuration
  end

  def self.configuration=(config)
    Thread.current[:sanity_configuration] = config
  end

  def self.configure
    yield configuration
  end
end
