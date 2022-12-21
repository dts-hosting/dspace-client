# frozen_string_literal: true

module DSpace
  class BitstreamResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/bitstreams.md"

    def default_endpoint
      "core/bitstreams"
    end

    def list(**params)
      # must be scoped to bundle
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "bitstreams", type: DSpace::Bitstream)
    end

    def retrieve(uuid:)
      DSpace::Bitstream.new client, get_request(uuid).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end
  end
end
