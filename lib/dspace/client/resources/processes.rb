# frozen_string_literal: true

module DSpace
  class ProcessesResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/scripts-endpoint.md"

    def default_endpoint
      "system/scripts"
    end

    def get (processId)
        DSpace::Process.new(
          client,
          DSpace::Request.new(client: client).get_request("server/api/system/processes/#{processId}").body
        )
    end
  end
end
