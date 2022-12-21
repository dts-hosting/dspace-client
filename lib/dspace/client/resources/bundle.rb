# frozen_string_literal: true

module DSpace
  class BundleResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/bundles.md"
    # ENDPOINT = "core/bundles"

    def default_endpoint
      "core/bundles"
    end

    def list(**params)
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "bundles", type: DSpace::Bundle)
    end

    def create(**attributes)
      # must be scoped to item
      DSpace::Bundle.new client, post_request(body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Bundle.new client, get_request(uuid).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end
  end
end
