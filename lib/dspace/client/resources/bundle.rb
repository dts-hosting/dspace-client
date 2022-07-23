# frozen_string_literal: true

module DSpace
  class BundleResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/bundles.md"
    ENDPOINT = "core/bundles"

    def list(**params)
      # must be scoped to item
      response = get_request(resolve_endpoint(ENDPOINT), params: params)
      DSpace::List.from_response(response, key: "bundles", type: DSpace::Bundle)
    end

    def create(**attributes)
      # must be scoped to item
      DSpace::Bundle.new post_request(resolve_endpoint(ENDPOINT), body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Bundle.new get_request("#{ENDPOINT}/#{uuid}").body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end
