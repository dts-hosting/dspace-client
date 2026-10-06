# frozen_string_literal: true

require "test_helper"

class ProcessesResourceTest < Minitest::Test
  def test_retrieve
    stubs = Faraday::Adapter::Test::Stubs.new
    client = build_stubbed_client(stubs)
    stubs.get(stub_url("system/processes/42")) do
      json_response({processId: 42, scriptName: "curate", processStatus: "COMPLETED", type: "process"})
    end

    process = client.processes.retrieve(process_id: 42)
    assert_equal DSpace::Process, process.class
    assert_equal "COMPLETED", process.processStatus
    stubs.verify_stubbed_calls
  end
end
