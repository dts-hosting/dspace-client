# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_list
    stub   = stub_request("eperson/epersons", response: stub_response(fixture: "users/list"))
    client = build_client(stub)
    users  = client.users.list

    assert_equal DSpace::Collection, users.class
    assert_equal DSpace::User, users.data.first.class
    assert_equal 1, users.total_pages
  end

  def test_create
    body = { name: "user@institution.edu", email: "user@institution.edu" }
    stub = stub_request("eperson/epersons", method: :post, body: body,
                                            response: stub_response(fixture: "users/create", status: 201))
    client = build_client(stub)

    user = client.users.create(**body)
    assert_equal DSpace::User, user.class
    assert_equal "user@institution.edu", user.email
  end

  def test_retrieve
    uuid   = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub   = stub_request("eperson/epersons/#{uuid}", response: stub_response(fixture: "users/retrieve"))
    client = build_client(stub)
    user   = client.users.retrieve(uuid: uuid)

    assert_equal DSpace::User, user.class
    assert_equal "user@institution.edu", user.email
  end

  def test_update
    uuid = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    body = { op: "replace", path: "/canLogin", value: "false" }
    stub = stub_request("eperson/epersons/#{uuid}", method: :patch, body: [body],
                                                    response: stub_response(fixture: "users/update"))
    client = build_client(stub)

    refute client.users.update(uuid: uuid, **body).canLogIn
  end

  def test_delete
    uuid = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    stub = stub_request("eperson/epersons/#{uuid}", method: :delete, response: stub_response(fixture: "users/delete"))
    client = build_client(stub)

    assert client.users.delete(uuid: uuid)
  end
end
