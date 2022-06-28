# frozen_string_literal: true

# DSpace
module DSpace
  include Services::Login

  # REST API Client
  class Client
    def initialize(config:)
      @config = config
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix   = @config.rest_url
        conn.ssl[:verify] = @config.ssl_verify

        conn.adapter  @config.adapter
        conn.request  :json, content_type: "application/json"
        conn.response :json, content_type: "application/json"
      end
    end
  end
end
