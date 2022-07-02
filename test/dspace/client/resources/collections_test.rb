# frozen_string_literal: true

require "test_helper"

class CollectionsResourceTest < Minitest::Test
  def test_list
    stub        = stub_request("core/collections", response: stub_response(fixture: "collections/list"))
    client      = build_client(stub)
    collection  = client.collections.list

    assert_equal DSpace::List, collection.class
    assert_equal DSpace::Collection, collection.data.first.class
    assert_equal 5, collection.total_pages
  end

  def test_create
    body = { name: "Collection of Sample Items" }
    stub = stub_request("core/collections", method: :post, body: body,
                                            response: stub_response(fixture: "collections/create", status: 201))
    client = build_client(stub)

    collection = client.collections.create(**body)
    assert_equal DSpace::Collection, collection.class
    assert_equal "Collection of Sample Items", collection.name
  end

  def test_retrieve
    uuid   = "1c11f3f1-ba1f-4f36-908a-3f1ea9a557eb"
    stub   = stub_request("core/collections/#{uuid}", response: stub_response(fixture: "collections/retrieve"))
    client = build_client(stub)

    collection = client.collections.retrieve(uuid: uuid)
    assert_equal DSpace::Collection, collection.class
    assert_equal "Collection of Sample Items", collection.name
  end

  def test_update
    uuid = "1c11f3f1-ba1f-4f36-908a-3f1ea9a557eb"
    body = { op: "replace", path: "/metadata/dc.description.abstract/0",
             value: { value: "This collection contains sample items updated." } }
    stub = stub_request("core/collections/#{uuid}", method: :patch, body: [body],
                                                    response: stub_response(fixture: "collections/update"))
    client = build_client(stub)

    assert_equal "This collection contains sample items updated.",
                 client.collections.update(uuid: uuid, **body).metadata["dc.description.abstract"].first.value
  end

  def test_delete
    uuid = "1c11f3f1-ba1f-4f36-908a-3f1ea9a557eb"
    stub = stub_request("core/collections/#{uuid}", method: :delete,
                                                    response: stub_response(fixture: "collections/delete"))
    client = build_client(stub)

    assert client.collections.delete(uuid: uuid)
  end
end
