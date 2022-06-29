# frozen_string_literal: true

# DSpace
module DSpace
  class UserResource < Request
    ENDPOINT = "eperson/epersons"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::Collection.from_response(response, key: "epersons", type: DSpace::User)
    end

    def create(**_attributes)
      DSpace::User.new JSON.parse(post_request(ENDPOINT, body: attributes).body)
    end

    def retrieve(uuid:)
      DSpace::User.new JSON.parse(get_request("#{ENDPOINT}/#{uuid}").body)
    end

    def update(uuid:, **_attributes)
      put_request("#{ENDPOINT}/#{uuid}", body: attributes)
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end
