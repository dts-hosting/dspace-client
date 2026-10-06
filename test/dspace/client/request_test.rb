# frozen_string_literal: true

require "test_helper"

class RequestTest < Minitest::Test
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new
    @client = build_stubbed_client(@stubs)
  end

  def test_resolve_path
    assert_equal "", DSpace::Request.new(client: @client).send(:resolve_path, "")
    assert_equal "core/items/abc", DSpace::Request.new(client: @client).send(:resolve_path, "core/items/abc")
    assert_equal "core/items", DSpace::Request.new(client: @client, endpoint: "core/items").send(:resolve_path, "")
    assert_equal "core/items/abc", DSpace::Request.new(client: @client, endpoint: "core/items").send(:resolve_path, "abc")
  end

  def test_path_without_endpoint_is_relative_to_rest_url
    @stubs.get(stub_url("core/items/abc")) { json_response({uuid: "abc"}) }
    response = DSpace::Request.new(client: @client).get_request("core/items/abc")
    assert_equal "abc", response.body["uuid"]
    @stubs.verify_stubbed_calls
  end

  def test_path_with_endpoint_is_relative_to_rest_url
    @stubs.get(stub_url("core/items/abc")) { json_response({uuid: "abc"}) }
    response = DSpace::Request.new(client: @client, endpoint: "core/items").get_request("abc")
    assert_equal "abc", response.body["uuid"]
    @stubs.verify_stubbed_calls
  end

  def test_endpoint_without_path
    @stubs.get(stub_url("core/items")) { json_response({}) }
    DSpace::Request.new(client: @client, endpoint: "core/items").get_request
    @stubs.verify_stubbed_calls
  end

  def test_payload_request_uses_type_as_http_method
    # capture inside the stub: Faraday reuses env, so env.body becomes the response body
    request_method = request_body = nil
    @stubs.put(stub_url("core/items/abc")) do |env|
      request_method = env.method
      request_body = env.body
      json_response({uuid: "abc", name: "Updated"})
    end

    response = DSpace::Request.new(client: @client, endpoint: "core/items")
      .payload_request("abc", type: :put, body: {name: "Updated"})

    assert_equal "Updated", response.body["name"]
    assert_equal :put, request_method
    assert_equal({"name" => "Updated"}, JSON.parse(request_body))
    @stubs.verify_stubbed_calls
  end
end
