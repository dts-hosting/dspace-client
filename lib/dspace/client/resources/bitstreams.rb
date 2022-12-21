# frozen_string_literal: true

module DSpace
  class BitstreamResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/bitstreams.md"
    ENDPOINT = "core/bitstreams"

    def list(**params)
      # must be scoped to bundle
      response = get_request(resolve_endpoint(ENDPOINT), params: params)
      DSpace::List.from_response(client, response, key: "bitstreams", type: DSpace::Bitstream)
    end

    def retrieve(uuid:)
      DSpace::Bitstream.new client, get_request("#{ENDPOINT}/#{uuid}").body
    end

    def delete(uuid:)
      delete_request("#{ENDPOINT}/#{uuid}")
    end
  end
end
