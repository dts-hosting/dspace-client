# frozen_string_literal: true

module DSpace
  class UserResource < Request
    CONTRACT       = "https://github.com/DSpace/RestContract/blob/main/epersons.md"
    ENDPOINT       = "eperson/epersons"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::Collection.from_response(response, key: "epersons", type: DSpace::User)
    end

    def search_by_email(email)
      DSpace::User.new search(email: email, method: "byEmail").body
    end

    def search_by_metadata(metadata)
      response = search(query: metadata, method: "byMetadata")
      DSpace::Collection.from_response(response, key: "epersons", type: DSpace::User)
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

    private

    def search(**params)
      search = params.delete(:method) { |_| "byEmail" }
      get_request("#{ENDPOINT}/search/#{search}", params: params)
    end
  end
end
