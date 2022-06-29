# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_list
    stub = stub_request("eperson/epersons", response: stub_response(fixture: "users/list"))
    config = DSpace::Configuration.new(settings: {
                                         adaptor: :test,
                                         rest_url: "https://example.dspace.org/server/api",
                                         username: "admin@dspacedirect.org",
                                         password: "admin",
                                         stubs: stub
                                       })
    client = DSpace::Client.new(config: config)

    users = client.users.list
    assert_equal DSpace::Collection, users.class
    assert_equal DSpace::User, users.data.first.class
    assert_equal 1, users.total_pages
  end

  def test_create
    body = { name: "user@institution.edu", email: "user@institution.edu" }
    stub = stub_request("eperson/epersons", method: :post, body: body,
                                            response: stub_response(fixture: "users/create", status: 201))
    config = DSpace::Configuration.new(settings: {
                                         adaptor: :test,
                                         rest_url: "https://example.dspace.org/server/api",
                                         username: "admin@dspacedirect.org",
                                         password: "admin",
                                         stubs: stub
                                       })
    client = DSpace::Client.new(config: config)

    user = client.users.create(**body)
    assert_equal DSpace::User, user.class
    assert_equal "user@institution.edu", user.email
  end

  def test_update
    uuid = "cb676a46-66fd-4dfb-b839-443f2e6c0b60"
    body = { op: "replace", path: "/canLogin", value: "false" }
    stub = stub_request("eperson/epersons/#{uuid}", method: :patch, body: [body],
                                                    response: stub_response(fixture: "users/update"))
    config = DSpace::Configuration.new(settings: {
                                         adaptor: :test,
                                         rest_url: "https://example.dspace.org/server/api",
                                         username: "admin@dspacedirect.org",
                                         password: "admin",
                                         stubs: stub
                                       })
    client = DSpace::Client.new(config: config)

    refute client.users.update(uuid: uuid, **body).canLogIn
  end
end
