# frozen_string_literal: true

module DSpace
  class UserResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/epersons.md"

    def default_endpoint
      "eperson/epersons"
    end

    def list(**params)
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "epersons", type: DSpace::User)
    end

    def create(**attributes)
      DSpace::User.new client, post_request(body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::User.new client, get_request(uuid).body
    end

    def update(uuid:, **attributes)
      DSpace::User.new client, put_request(uuid, body: [attributes]).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end

    def search(method:, **)
      handle_search(resource: DSpace::User, key: "epersons", method: method, **)
    end

    def search_by_email(email)
      handle_search(resource: DSpace::User, key: "epersons", method: "byEmail", list: false,
        email: email)
    end

    def search_by_metadata(metadata)
      handle_search(resource: DSpace::User, key: "epersons", method: "byMetadata", query: metadata)
    end
  end
end
