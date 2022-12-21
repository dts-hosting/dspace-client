# frozen_string_literal: true

module DSpace
  class BrowseResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/browses.md"

    def default_endpoint
      "discover/browses"
    end

    def list(**params)
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "browses", type: DSpace::Browse)
    end

    def retrieve(id:)
      DSpace::Browse.new client, get_request(id).body
    end
  end
end
