# frozen_string_literal: true

require "test_helper"

class ProcessObjectTest < Minitest::Test
  def test_files
    stubs = Faraday::Adapter::Test::Stubs.new
    client = build_stubbed_client(stubs)
    stubs.get(stub_url("system/processes/42/files")) do
      json_response({
        _embedded: {files: [{uuid: "file-uuid", name: "output.log", type: "bitstream"}]},
        page: {number: 0, size: 20, totalElements: 1, totalPages: 1}
      })
    end

    files = DSpace::Process.new(client, {processId: 42}).files
    assert_equal DSpace::List, files.class
    assert_equal DSpace::File, files.data.first.class
    assert_equal "output.log", files.data.first.name
    stubs.verify_stubbed_calls
  end
end
