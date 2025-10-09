# frozen_string_literal: true

require "ostruct"

module DSpace
  class Object < OpenStruct
    attr_reader :client

    def initialize(client, attributes)
      @client = client
      super(to_ostruct(attributes))
    end

    def to_ostruct(obj)
      case obj
      when Hash
        OpenStruct.new(obj.transform_values { |val| to_ostruct(val) })
      when Array
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end

    def to_hash(obj = nil)
      obj ||= self
      obj.to_h.transform_values do |value|
        if value.is_a?(OpenStruct)
          to_hash(value)
        elsif value.is_a?(Array)
          value.map do |v|
            v.is_a?(String) ? v : to_hash(v)
          end
        else
          value
        end
      end
    end
  end
end
