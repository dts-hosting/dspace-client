# frozen_string_literal: true

module DSpace
  class CollectionResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/collections.md"
    ENDPOINT = "core/collections"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params) # may be scoped to community
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    def create(**attributes)
      DSpace::Collection.new post_request(ENDPOINT, body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Collection.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::Collection.new put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end
