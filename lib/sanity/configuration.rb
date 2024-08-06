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

    def to_h
      instance_variables.each_with_object({}) do |var, obj|
        obj[var.to_s.delete("@").to_sym] = instance_variable_get(var)
      end
    end
  end

  class << self
    attr_accessor :use_global_config

    def configuration
      if use_global_config
        @configuration ||= Configuration.new
      else
        Thread.current[:sanity_configuration] ||= Configuration.new
      end
    end
    alias_method :config, :configuration

    def configuration=(config)
      if use_global_config
        @configuration = config
      else
        Thread.current[:sanity_configuration] = config
      end
    end

    def configure
      yield configuration
    end
  end
end
