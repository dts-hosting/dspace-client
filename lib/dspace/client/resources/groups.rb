# frozen_string_literal: true

module DSpace
  class GroupResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/epersongroups.md"

    def default_endpoint
      "eperson/groups"
    end

    def list(**params)
      response = get_request(params: params)
      DSpace::List.from_response(client, response, key: "groups", type: DSpace::Group)
    end

    def create(**attributes)
      DSpace::Group.new client, post_request(body: attributes).body
    end

    def retrieve(uuid:)
      DSpace::Group.new client, get_request(uuid).body
    end

    def update(uuid:, **attributes)
      DSpace::Group.new client, put_request(uuid, body: [attributes]).body
    end

    def delete(uuid:)
      delete_request(uuid)
    end

    def search(method:, **)
      handle_search(resource: DSpace::Group, key: "groups", method: method, **)
    end

    def is_not_member_of(uuid, metadata)
      handle_search(resource: DSpace::Group, key: "groups", method: "isNotMemberOf", group: uuid,
        query: metadata)
    end

    def search_by_metadata(metadata)
      handle_search(resource: DSpace::Group, key: "groups", method: "byMetadata", query: metadata)
    end

    def add_eperson
      # TODO: implement
    end
  end
end
