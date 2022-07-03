# frozen_string_literal: true

module DSpace
  class BrowseResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/browses.md"
    ENDPOINT = "discover/browses"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params)
      DSpace::List.from_response(response, key: "browses", type: DSpace::Browse)
    end

    def retrieve(id:)
      DSpace::Browse.new get_request("#{ENDPOINT}/#{id}").body
    end
  end
end
