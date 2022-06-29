# frozen_string_literal: true

# DSpace
module DSpace
  # REST API Configuration
  class Configuration
    attr_reader :adapter, :rest_url, :username, :password, :ssl_verify, :stubs

    def initialize(settings: {})
      @adapter    = settings.fetch(:adaptor, Faraday.default_adapter)
      @rest_url   = settings.fetch(:rest_url) { raise DSpace::ConfigurationError, "REST URL required" }
      @ssl_verify = settings.fetch(:ssl_verify, true)
      @stubs      = settings.fetch(:stubs, nil)

      # authentication
      @username = settings.fetch(:username) { raise DSpace::ConfigurationError, "USERNAME required" }
      @password = settings.fetch(:password) { raise DSpace::ConfigurationError, "PASSOWRD required" }
    end
  end

  # return a DSpace::Configuration from loading ENV or ~/.dspaceclientrc
  def self.find
    # TODO
    raise "Not implemented"
  end
end
