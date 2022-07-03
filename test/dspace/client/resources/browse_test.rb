# frozen_string_literal: true

require "test_helper"

class BrowsesResourceTest < Minitest::Test
  def test_list
    client = build_client
    VCR.use_cassette("browses_list") do
      client.login
      browses = client.browses.list
      assert_equal DSpace::List, browses.class
      assert_equal DSpace::Browse, browses.data.first.class
      assert_equal 1, browses.total_pages
    end
  end

  def test_retrieve
    id     = "dateissued"
    client = build_client
    VCR.use_cassette("browses_retrieve") do
      client.login
      browse = client.browses.retrieve(id: id)
      assert_equal DSpace::Browse, browse.class
      assert_equal "dateissued", browse.id
    end
  end
end
