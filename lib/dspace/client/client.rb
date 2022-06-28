# frozen_string_literal: true

# DSpace
module DSpace
  # REST API Client
  class Client
    include DSpace::Request

    def initialize(config:)
      @authorization = nil
      @config        = config
      @token         = nil
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix   = @config.rest_url
        conn.ssl[:verify] = @config.ssl_verify

        conn.adapter @config.adapter
        conn.use     :cookie_jar

        conn.request  :json, content_type: "application/json"
        conn.response :json, content_type: "application/json"
      end
    end
  end
end
