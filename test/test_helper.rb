# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "dspace/client"
require "minitest/autorun"
require "faraday"
require "json"
require "vcr"

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
  config.cassette_library_dir = "test/fixtures/"
  config.hook_into :faraday

  config.filter_sensitive_data("<AUTHENTICATION>") do |interaction|
    interaction.request.body if interaction.request.body =~ /user.*password/
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
      config = DSpace::Configuration.new(settings: {
                                           rest_url: ENV.fetch("DSPACE_CLIENT_REST_URL"),
                                           username: ENV.fetch("DSPACE_CLIENT_USERNAME"),
                                           password: ENV.fetch("DSPACE_CLIENT_PASSWORD")
                                         })
      DSpace::Client.new(config: config)
    end
  end
end
