# frozen_string_literal: true

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
      DSpace::Request.new(client: self).get_request(path, params: params, headers: headers)
    end

    # Authentication is special
    def login
      DSpace::AuthnResource.new(client: self).create
    end

    def logout
      DSpace::AuthnResource.new(client: self).delete
    end

    def status
      DSpace::AuthnResource.new(client: self).retrieve
    end

    # Resources
    def collections
      DSpace::CollectionResource.new(client: self)
    end

    def communities
      DSpace::CommunityResource.new(client: self)
    end

    def users
      DSpace::UserResource.new(client: self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix   = @config.rest_url
        conn.ssl[:verify] = @config.ssl_verify

        conn.adapter @config.adapter, @config.stubs
        conn.use     :cookie_jar

        conn.request  :json
        conn.response :json
      end
    end
  end
end
