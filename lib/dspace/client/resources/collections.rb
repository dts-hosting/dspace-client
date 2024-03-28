# frozen_string_literal: true

module DSpace
  class CollectionResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/collections.md"

    def default_endpoint
      "core/collections"
    end

    def list(**params)
      response = get_request(params: params) # may be scoped to community
      DSpace::List.from_response(client, response, key: "collections", type: DSpace::Collection)
    end

    def create(parent:, **attributes)
      DSpace::Collection.new client, post_request(body: attributes, params: {parent: parent}).body
    end

    def retrieve(uuid:)
      DSpace::Collection.new client, get_request(uuid).body
    end

    def update(uuid:, **attributes)
      DSpace::Collection.new client, put_request(uuid, body: [attributes]).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end

    def search(method:, **)
      handle_search(resource: DSpace::Collection, key: "collections", method: method, **)
    end

    def search_admin_authorized
      handle_search(resource: DSpace::Collection, key: "collections", method: "findAdminAuthorized")
    end

    def search_submit_authorized(metadata)
      handle_search(resource: DSpace::Collection, key: "collections", method: "findSubmitAuthorized",
        query: metadata)
    end

    def search_submit_authorized_by_community(uuid)
      handle_search(resource: DSpace::Collection, key: "collections",
        method: "findSubmitAuthorizedByCommunity", uuid: uuid)
    end

    def search_submit_authorized_by_entity_type(entity_type)
      handle_search(resource: DSpace::Collection, key: "collections",
        method: "findSubmitAuthorizedByEntityType", entityType: entity_type)
    end
  end
end
