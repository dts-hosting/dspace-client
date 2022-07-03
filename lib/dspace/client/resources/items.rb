# frozen_string_literal: true

module DSpace
  class ItemResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/items.md"
    ENDPOINT = "core/items"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params) # may be scoped to browse
      DSpace::List.from_response(response, key: "items", type: DSpace::Item)
    end
  end
end
