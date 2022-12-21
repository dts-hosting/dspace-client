# frozen_string_literal: true

module DSpace
  class SearchResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/search-endpoint.md"

    def default_endpoint
      "discover/search"
    end

    # query, dsoType (all,community,collection,item), scope (uuid), configuration, f.*, page, size, sort
    def objects(**params)
      response = get_request("objects", params: params)
      DSpace::List.from_search_response(client, response)
    end
    alias list objects
  end
end
