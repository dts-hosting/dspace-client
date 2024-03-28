# frozen_string_literal: true

require "test_helper"

class ObjectTest < Minitest::Test
  def test_creating_object_from_hash
    client = build_client
    assert_equal "bar", DSpace::Object.new(client, foo: "bar").foo
  end

  def test_nested_hash
    client = build_client
    assert_equal "foobar", DSpace::Object.new(client, foo: {bar: {baz: "foobar"}}).foo.bar.baz
  end

  def test_nested_number
    client = build_client
    assert_equal 1, DSpace::Object.new(client, foo: {bar: 1}).foo.bar
  end

  def test_array
    client = build_client
    object = DSpace::Object.new(client, foo: [{bar: :baz}])
    assert_equal OpenStruct, object.foo.first.class
    assert_equal :baz, object.foo.first.bar
  end
end
