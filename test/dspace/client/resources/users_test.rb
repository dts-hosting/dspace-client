# frozen_string_literal: true

require "test_helper"

class UsersResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("users_list") do
      client.login
      users = client.users.list
      assert_equal DSpace::List, users.class
      assert_equal DSpace::User, users.data.first.class
      assert_equal 51, users.total_pages
    end
  end

  def test_create
    body = {name: "user@institution.edu", email: "user@institution.edu"}
    client = build_client
    VCR.use_cassette("users_create") do
      client.login
      user = client.users.create(**body)
      assert_equal DSpace::User, user.class
      assert_equal "user@institution.edu", user.email
    end
  end

  def test_retrieve
    uuid = "de9209ca-3cd9-49a1-a3ea-5fea15c31cb5"
    client = build_client
    VCR.use_cassette("users_retrieve") do
      client.login
      user = client.users.retrieve(uuid: uuid)
      assert_equal DSpace::User, user.class
      assert_equal "user@institution.edu", user.email
    end
  end

  def test_update
    uuid = "de9209ca-3cd9-49a1-a3ea-5fea15c31cb5"
    body = {op: "replace", path: "/canLogin", value: "true"}
    client = build_client
    VCR.use_cassette("users_update") do
      client.login
      assert client.users.update(uuid: uuid, **body).canLogIn
    end
  end

  def test_delete
    uuid = "de9209ca-3cd9-49a1-a3ea-5fea15c31cb5"
    client = build_client
    VCR.use_cassette("users_delete") do
      client.login
      assert client.users.delete(uuid: uuid)
    end
  end

  def test_search_by_email
    client = build_client
    VCR.use_cassette("users_search_by_email") do
      client.login
      user = client.users.search_by_email(client.config.username)
      assert_equal DSpace::User, user.class
      assert_equal client.config.username, user.email
    end
  end

  def test_search_by_metadata
    client = build_client
    VCR.use_cassette("users_search_by_metadata") do
      client.login
      users = client.users.search_by_metadata("lyrasis")
      assert_equal DSpace::List, users.class
      assert_equal 1, users.total_pages
    end
  end
end
