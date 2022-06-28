# frozen_string_literal: true

# DSpace
module DSpace
  # UserResource
  class UserResource < Request
    ENDPOINT = "eperson/epersons"

    def list(**params)
      response = get_request(ENDPOINT, params: params)
      DSpace::Collection.from_response(response, key: "epersons", type: DSpace::User)
    end

    def create(**_attributes)
      # DSpace::User.new post_request(ENDPOINT, body: attributes).body["eperson"]
      raise "Not implemented"
    end

    def retrieve(uuid:)
      # DSpace::User.new get_request("#{ENDPOINT}/#{uuid}").body["eperson"]
      raise "Not implemented"
    end

    def update(uuid:, **_attributes)
      # patch_request("#{ENDPOINT}/#{uuid}", body: attributes)
      raise "Not implemented"
    end

    def delete(uuid:)
      # delete_request("#{ENDPOINT}/#{uuid}")
      raise "Not implemented"
    end
  end
end
