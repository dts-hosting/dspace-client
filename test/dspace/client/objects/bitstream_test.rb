# frozen_string_literal: true

require "test_helper"

class BitstreamObjectTest < Minitest::Test
  def test_content
    stubs = Faraday::Adapter::Test::Stubs.new
    client = build_stubbed_client(stubs)
    # content uses its own client, which logs in first
    stubs.post(stub_url("authn/login")) do
      [200, {"Authorization" => "Bearer token", "DSPACE-XSRF-TOKEN" => "xsrf"}, ""]
    end
    stubs.get(stub_url("core/bitstreams/bitstream-uuid/content")) do
      [200, {"Content-Type" => "text/plain"}, "file contents"]
    end

    content = DSpace::Bitstream.new(client, {uuid: "bitstream-uuid"}).content
    assert_equal "file contents", content
    stubs.verify_stubbed_calls
  end
end
