# frozen_string_literal: true

module DSpace
  class Script < Object
    def run(parameters)
      DSpace::Process.new(
        client,
        DSpace::Request.new(client: client, endpoint: "system/scripts/#{name}/processes").post_request(body: parameters, headers: { 'Content-Type': 'multipart/form-data; boundary=--------------------------043061484975945576224864' } ).body # , 
      )
    end
  end
end
