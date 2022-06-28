# frozen_string_literal: true

# DSpace
module DSpace
  # Services
  module Services
    # Login
    module Login
      ENDPOINT = "authn/login"

      def login
        post(ENDPOINT, {}) # Get a XSRF token
        response = connection.post(ENDPOINT) do |req|
          req.body = URI.encode_www_form({ user: @config.username, password: @config.password })
          req.headers["Content-Type"] = "application/x-www-form-urlencoded"
          req.headers["X-XSRF-Token"] = @token
        end
        refresh_authorization(response)
      end
    end
  end
end
