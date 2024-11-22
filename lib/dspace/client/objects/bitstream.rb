# frozen_string_literal: true

module DSpace
  class Bitstream < Object
    def content
      DSpace::Request.new(client: client).get_request("server/api/core/bitstreams/#{uuid}/content").body
    end
  end
end
