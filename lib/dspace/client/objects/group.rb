# frozen_string_literal: true

module DSpace
  class Group < Object
    def epersons
      DSpace::UserResource.new(client: client, endpoint: "eperson/groups/#{uuid}/epersons")
    end

    def subgroups
      DSpace::GroupResource.new(client: client, endpoint: "eperson/groups/#{uuid}/subgroups")
    end

    def add_eperson(eperson_uuid:)
      DSpace::Request.new(client: client, endpoint: "eperson/groups/#{uuid}/epersons").post_request(
        body: "#{client.config.rest_url}/eperson/epersons/#{eperson_uuid}",
        headers: {"Content-Type": "text/uri-list"}
      )
    end
  end
end
