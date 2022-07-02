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

    def search_admin_authorized
      response = search(method: "findAdminAuthorized")
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    def search_submit_authorized(metadata)
      response = search(query: metadata, method: "findSubmitAuthorized")
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    def search_submit_authorized_by_community(uuid)
      response = search(uuid: uuid, method: "findSubmitAuthorizedByCommunity")
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    def search_submit_authorized_by_entity_type(entity_type)
      response = search(entityType: entity_type, method: "findSubmitAuthorizedByEntityType")
      DSpace::List.from_response(response, key: "collections", type: DSpace::Collection)
    end

    private

    def search(**params)
      search = params.delete(:method) { |_| raise DSpace::InvalidSearchError, "Search method required." }
      get_request("#{ENDPOINT}/search/#{search}", params: params)
    end
  end
end
