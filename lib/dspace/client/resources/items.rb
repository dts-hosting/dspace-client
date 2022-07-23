# frozen_string_literal: true

module DSpace
  class ItemResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/items.md"
    ENDPOINT = "core/items"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params) # may be scoped to browse
      DSpace::List.from_response(response, key: "items", type: DSpace::Item)
    end

    def create(parent:, **attributes)
      DSpace::Item.new post_request(ENDPOINT, body: attributes, params: { owningCollection: parent }).body
    end

    def retrieve(uuid:)
      DSpace::Item.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::Item.new put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end
