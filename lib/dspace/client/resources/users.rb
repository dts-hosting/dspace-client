# frozen_string_literal: true

module DSpace
  class UserResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/epersons.md"
    ENDPOINT = "eperson/epersons"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::List.from_response(response, key: "epersons", type: DSpace::User)
    end

    def create(**attributes)
      DSpace::User.new post_request(ENDPOINT, body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::User.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def update(uuid:, **attributes)
      DSpace::User.new put_request("#{ENDPOINT}/#{uuid}", body: [attributes]).body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end

    def search(method:, **attributes)
      handle_search(path: ENDPOINT, resource: DSpace::User, key: "epersons", method: method, **attributes)
    end

    def search_by_email(email)
      handle_search(path: ENDPOINT, resource: DSpace::User, key: "epersons", method: "byEmail", list: false,
                    email: email)
    end

    def search_by_metadata(metadata)
      handle_search(path: ENDPOINT, resource: DSpace::User, key: "epersons", method: "byMetadata", query: metadata)
    end
  end
end
