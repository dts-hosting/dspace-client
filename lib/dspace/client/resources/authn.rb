# frozen_string_literal: true

# DSpace
module DSpace
  class AuthnResource < Request
    def create
      login_request
    end

    def retrieve
      # TODO: status
      raise "Not implemented"
    end

    def delete
      # TODO: logout_request
      raise "Not implemented"
    end
  end
end
