# frozen_string_literal: true

module DSpace
  class AuthnResource < Request
    CONTRACT = "https://github.com/DSpace/RestContract/blob/main/authentication.md"

    def default_endpoint
      "authn"
    end

    def create
      login_request
    end

    def retrieve
      get_request("status").body
    end

    def update
      login_request # just resend, if logged in will be refreshed
    end

    def delete
      post_request("logout", body: "").status
    end

    private

    def login_request
      # 1. Get a XSRF token
      response = client.connection.post("#{default_endpoint}/login") do |req|
        handle_request_for_authentication(req)
      end
      refresh_token(response)

      # 2. Repeat with XSRF token
      response = client.connection.post("#{default_endpoint}/login") do |req|
        handle_request_for_authentication(req)
      end
      refresh_authorization(response)
      refresh_token(response)
      handle_response(response)
    end
  end
end
