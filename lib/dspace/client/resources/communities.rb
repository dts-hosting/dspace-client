# frozen_string_literal: true

module DSpace
  class CommunityResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/communities.md"
    ENDPOINT = "core/communities"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::List.from_response(response, key: "communities", type: DSpace::Community)
    end

    def create(**attributes)
      DSpace::Community.new post_request(ENDPOINT, body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Community.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::Community.new put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end

    def search_by_metadata(metadata)
      response = search(query: metadata, method: "findAdminAuthorized")
      DSpace::List.from_response(response, key: "communities", type: DSpace::Community)
    end

    def search_top
      DSpace::Community.new search(method: "top").body
    end

    private

    def search(**params)
      search = params.delete(:method) { |_| "top" }
      get_request("#{ENDPOINT}/search/#{search}", params: params)
    end
  end
end
