# frozen_string_literal: true

module DSpace
  class Process < Object
    def files
      response = DSpace::Request.new(client: client).get_request("server/api/system/processes/#{processId}/files")
      DSpace::List.from_response(client, response, key: "files", type: DSpace::File)
    end

    def refresh
      client.processes.retrieve(process_id: processId)
    end
  end
end
