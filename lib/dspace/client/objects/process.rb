# frozen_string_literal: true

module DSpace
  class Process < Object
    def refresh()
      DSpace::Process.new(
        client,
        DSpace::Request.new(client: client).get_request("server/api/system/processes/#{processId}").body
      )
    end
  
    def files()
      response = DSpace::Request.new(client: client).get_request("server/api/system/processes/#{processId}/files")
      DSpace::List.from_response(client, response, key: "files", type: DSpace::File)
    end
  end
end
