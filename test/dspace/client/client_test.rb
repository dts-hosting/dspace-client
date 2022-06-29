# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  def test_client_config
    config = DSpace::Configuration.new(settings: {
                                         rest_url: "https://example.dspace.org/server/api",
                                         username: "admin@dspacedirect.org",
                                         password: "admin"
                                       })
    client = DSpace::Client.new config: config
    assert_equal "admin@dspacedirect.org", client.config.username
    assert_equal true, client.config.ssl_verify
  end
end
