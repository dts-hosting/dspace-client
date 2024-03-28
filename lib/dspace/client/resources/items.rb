# frozen_string_literal: true

module DSpace
  class ItemResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/items.md"

    def default_endpoint
      "core/items"
    end

    def list(**params)
      response = get_request(params: params) # may be scoped to browse
      DSpace::List.from_response(client, response, key: "items", type: DSpace::Item)
    end

    def create(parent:, **attributes)
      DSpace::Item.new client, post_request(body: attributes, params: {owningCollection: parent}).body
    end

    def retrieve(uuid:)
      DSpace::Item.new client, get_request(uuid).body
    end

    def update(uuid:, **attributes)
      DSpace::Item.new client, put_request(uuid, body: [attributes]).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end
  end
end
