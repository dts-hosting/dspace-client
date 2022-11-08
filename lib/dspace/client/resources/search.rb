# frozen_string_literal: true

module DSpace
  class SearchResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/search-endpoint.md"
    ENDPOINT = "discover/search"

    # query, dsoType (all,community,collection,item), scope (uuid), configuration, f.*, page, size, sort
    def objects(**params)
      response = get_request("#{ENDPOINT}/objects", params: params)
      DSpace::List.from_search_response(client, response)
    end
    alias list objects
  end
end
