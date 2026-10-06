# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"
require "minitest/autorun"
require "faraday"
require "json"
require "vcr"

# Cassettes replay without any ENV. Set the DSPACE_CLIENT_* ENV vars to record new ones.
DSPACE_RECORDING = ENV.key?("DSPACE_CLIENT_REST_URL")
DSPACE_TEST_SETTINGS = {
  rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL", "https://example.dspace.org/server/api"),
  username: ENV.fetch("DSPACE_CLIENT_USERNAME", "admin@example.org"),
  password: ENV.fetch("DSPACE_CLIENT_PASSWORD", "admin")
}.freeze

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "test/fixtures/"
  config.hook_into :faraday
  config.default_cassette_options = {record: DSPACE_RECORDING ? :once : :none}

  # Cassettes are recorded with a placeholder for the REST URL so they replay against any rest_url
  config.filter_sensitive_data("<DSPACE_REST_URL>") { DSPACE_TEST_SETTINGS[:rest_url] }

  config.filter_sensitive_data("<AUTHENTICATION>") do |interaction|
    interaction.request.body if /user.*password/.match?(interaction.request.body)
  end

  config.filter_sensitive_data("<TOKEN>") do |interaction|
    interaction.request.headers["Authorization"]&.first
  end

  config.filter_sensitive_data("<TOKEN>") do |interaction|
    interaction.response.headers["authorization"]&.first
  end
end

module Minitest
  class Test
    def build_client
      # TODO: Sandbox: https://sandbox.dspacedirect.net/server/api, admin@dspacedirect.org, admin
      config = DSpace::Configuration.new(settings: DSPACE_TEST_SETTINGS)
      DSpace::Client.new(config: config)
    end

    # A client backed by Faraday's test adapter: no network, no cassettes
    def build_stubbed_client(stubs, response: :json)
      config = DSpace::Configuration.new(settings: {
        rest_url: "https://example.dspace.org/server/api",
        username: "admin@example.org",
        password: "admin",
        adaptor: :test,
        stubs: stubs
      })
      DSpace::Client.new(config: config, response: response)
    end

    def stub_url(path)
      "https://example.dspace.org/server/api/#{path}"
    end

    def json_response(body, status: 200)
      [status, {"Content-Type" => "application/json"}, JSON.generate(body)]
    end
  end
end
