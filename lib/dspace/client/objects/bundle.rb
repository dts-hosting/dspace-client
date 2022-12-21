# frozen_string_literal: true

module DSpace
  class Bundle < Object
    def bitstreams
      DSpace::BitstreamResource.new(client: client, endpoint: "core/bundles/#{uuid}/bitstreams")
    end
  end
end
