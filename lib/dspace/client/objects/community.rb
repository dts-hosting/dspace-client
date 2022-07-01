# frozen_string_literal: true

module DSpace
  class Community < Object
    def collections(client:)
      DSpace::CollectionResource.new(client: client, endpoint: "core/communities/#{uuid}/collections")
    end
  end
end
