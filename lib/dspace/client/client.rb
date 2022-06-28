# frozen_string_literal: true

# DSpace
module DSpace
  # REST API Client
  class Client
    include Services::Login

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

    def get(path, params = {}, headers = {})
      response = connection.get(path) do |req|
        req.params  = params
        req.headers = headers.merge({ "X-XSRF-Token" => @token })
        req.headers["Authorization"] = @authorization if @authorization
      end
      refresh_token(response)
    end

    def post(path, payload, params = {}, headers = {})
      response = connection.post(path) do |req|
        req.body    = payload.to_json
        req.params  = params
        req.headers = headers.merge({ "Authorization" => @authorization, "X-XSRF-Token" => @token })
      end
      refresh_token(response)
    end

    private

    def refresh_authorization(response)
      @authorization = response.headers["Authorization"] if response.headers.key?("Authorization")
      response
    end

    def refresh_token(response)
      @token = response.headers["DSPACE-XSRF-TOKEN"] if response.headers.key?("DSPACE-XSRF-TOKEN")
      response
    end
  end
end
