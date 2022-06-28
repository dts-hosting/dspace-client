# frozen_string_literal: true

# DSpace
module DSpace
  # REST API Client
  class Client
    attr_accessor :authorization, :token
    attr_reader   :config

    def initialize(config:)
      @authorization = nil
      @config        = config
      @token         = nil
    end

    # Expose basic operations: (get, post, put, delete)
    def get(path, params = {}, headers = {})
      DSpace::Request.new(client: self).get_request(path, params, headers)
    end

    # Authentication is special
    def login
      DSpace::AuthnResource.new(client: self).create
    end

    # Resources
    def users
      DSpace::UserResource.new(client: self)
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
