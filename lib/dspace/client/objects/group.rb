# frozen_string_literal: true

module DSpace
  class Group < Object
    def epersons
      DSpace::UserResource.new(client: client, endpoint: "eperson/groups/#{uuid}/epersons")
    end

    def subgroups
      DSpace::GroupResource.new(client: client, endpoint: "eperson/groups/#{uuid}/subgroups")
    end
  end
end
