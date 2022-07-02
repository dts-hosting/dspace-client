# frozen_string_literal: true

require "test_helper"

class CommunitiesResourceTest < Minitest::Test
  def test_list
    stub        = stub_request("core/communities", response: stub_response(fixture: "communities/list"))
    client      = build_client(stub)
    communities = client.communities.list

    assert_equal DSpace::List, communities.class
    assert_equal DSpace::Community, communities.data.first.class
    assert_equal 4, communities.total_pages
  end

  def test_create
    body = { name: "OR2017 - Demonstration" }
    stub = stub_request("core/communities", method: :post, body: body,
                                            response: stub_response(fixture: "communities/create", status: 201))
    client = build_client(stub)

    community = client.communities.create(**body)
    assert_equal DSpace::Community, community.class
    assert_equal "OR2017 - Demonstration", community.name
  end

  def test_retrieve
    uuid   = "7669c72a-3f2a-451f-a3b9-9210e7a4c02f"
    stub   = stub_request("core/communities/#{uuid}", response: stub_response(fixture: "communities/retrieve"))
    client = build_client(stub)

    community = client.communities.retrieve(uuid: uuid)
    assert_equal DSpace::Community, community.class
    assert_equal "OR2017 - Demonstration", community.name
  end

  def test_update
    uuid = "7669c72a-3f2a-451f-a3b9-9210e7a4c02f"
    body = { op: "replace", path: "/metadata/dc.description/0", value: { value: "First description updated" } }
    stub = stub_request("core/communities/#{uuid}", method: :patch, body: [body],
                                                    response: stub_response(fixture: "communities/update"))
    client = build_client(stub)

    assert_equal "First description updated",
                 client.communities.update(uuid: uuid, **body).metadata["dc.description"].first.value
  end

  def test_delete
    uuid = "7669c72a-3f2a-451f-a3b9-9210e7a4c02f"
    stub = stub_request("core/communities/#{uuid}", method: :delete,
                                                    response: stub_response(fixture: "communities/delete"))
    client = build_client(stub)

    assert client.communities.delete(uuid: uuid)
  end
end
