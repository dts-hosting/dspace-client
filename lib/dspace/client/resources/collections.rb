# frozen_string_literal: true

module DSpace
  class CollectionResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/collections.md"
    ENDPOINT = "core/collections"

    def list(**params)
      response = get_request(resolve_endpoint(ENDPOINT), params: params) # may be scoped to community
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    def create(parent:, **attributes)
      DSpace::Collection.new post_request(ENDPOINT, body: attributes, params: { parent: parent }).body
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

    def search(method:, **attributes)
      handle_search(path: ENDPOINT, resource: DSpace::Collection, key: "collections", method: method, **attributes)
    end

    def search_admin_authorized
      handle_search(path: ENDPOINT, resource: DSpace::Collection, key: "collections", method: "findAdminAuthorized")
    end

    def search_submit_authorized(metadata)
      handle_search(path: ENDPOINT, resource: DSpace::Collection, key: "collections", method: "findSubmitAuthorized",
                    query: metadata)
    end

    def search_submit_authorized_by_community(uuid)
      handle_search(path: ENDPOINT, resource: DSpace::Collection, key: "collections",
                    method: "findSubmitAuthorizedByCommunity", uuid: uuid)
    end

    def search_submit_authorized_by_entity_type(entity_type)
      handle_search(path: ENDPOINT, resource: DSpace::Collection, key: "collections",
                    method: "findSubmitAuthorizedByEntityType", entityType: entity_type)
    end
  end
end
