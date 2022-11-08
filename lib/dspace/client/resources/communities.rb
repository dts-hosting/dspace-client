# frozen_string_literal: true

module DSpace
  class CommunityResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/communities.md"
    ENDPOINT = "core/communities"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params) # may be scoped to subcommunity
      DSpace::List.from_response(client, response, key: "communities", type: DSpace::Community)
    end

    def create(**attributes)
      DSpace::Community.new client, post_request(ENDPOINT, body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Community.new client, get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::Community.new client, put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end

    def search(method:, **attributes)
      handle_search(path: ENDPOINT, resource: DSpace::Community, key: "communities", method: method, **attributes)
    end

    def search_by_metadata(metadata)
      handle_search(path: ENDPOINT, resource: DSpace::Community, key: "communities", method: "findAdminAuthorized",
                    query: metadata)
    end

    def search_top
      handle_search(path: ENDPOINT, resource: DSpace::Community, key: "communities", method: "top", list: false)
    end
  end
end
