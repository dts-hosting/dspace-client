# frozen_string_literal: true

# DSpace
module DSpace
  # UserResource
  class UserResource < Request
    def list(**_params)
      raise "Not implemented"
    end

    def create(**_attributes)
      raise "Not implemented"
    end

    def retrieve(user_id:)
      raise "Not implemented"
    end

    def update(user_id:, **_attributes)
      raise "Not implemented"
    end

    def delete(user_id:)
      raise "Not implemented"
    end
  end
end
