# frozen_string_literal: true

module DSpace
  class ScriptsResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/scripts-endpoint.md"

    def default_endpoint
      "system/scripts"
    end

    def list(**params)
      response = get_request(params: params) # may be scoped to browse
      DSpace::List.from_response(client, response, key: "scripts", type: DSpace::Script)
    end

    def retrieve(name:)
      DSpace::Script.new client, get_request(name).body
    end
  end
end
