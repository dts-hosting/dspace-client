# frozen_string_literal: true

module DSpace
  class Bitstream < Object
    def content(headers = {})
      # awkward, but we need to create a new client to get the bitstream content
      # to suppress the otherwise very convenient :json response type
      bitstream_client = DSpace::Client.new(config: client.config, response: nil)
      bitstream_client.login

      DSpace::Request.new(client: bitstream_client).get_request(
        "server/api/core/bitstreams/#{uuid}/content",
        headers: headers
      ).body
    end
  end
end
