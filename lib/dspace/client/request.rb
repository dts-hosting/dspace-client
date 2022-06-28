# frozen_string_literal: true

# DSpace
module DSpace
  # Request
  module Request
    def delete(path, params = {}, headers = {})
      response = connection.delete(path) do |req|
        handle_request(req, params, headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def get(path, params = {}, headers = {})
      response = connection.get(path) do |req|
        handle_request(req, params, headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def login
      # Get a XSRF token
      response = connection.post("authn/login") do |req|
        handle_request_for_authentication(req)
      end
      refresh_token(response)

      response = connection.post("authn/login") do |req|
        handle_request_for_authentication(req)
      end
      refresh_authorization(response)
      refresh_token(response)
      handle_response(response)
    end

    def post(path, body, params = {}, headers = {})
      response = connection.post(path) do |req|
        handle_request_with_payload(req, body, params, headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def put(path, body, params = {}, headers = {})
      response = connection.patch(path) do |req|
        handle_request_with_payload(req, body, params, headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    private

    def handle_request(req, params, headers)
      req.params  = params
      req.headers = headers.merge({ "X-XSRF-Token" => @token })
      req.headers["Authorization"] = @authorization if @authorization
    end

    def handle_request_for_authentication(req)
      req.body = URI.encode_www_form({ user: @config.username, password: @config.password })
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.headers["X-XSRF-Token"] = @token
    end

    def handle_request_with_payload(req, body, params, headers)
      req.body    = body
      req.params  = params
      req.headers = headers.merge({ "Authorization" => @authorization, "X-XSRF-Token" => @token })
    end

    def handle_response(response)
      case response.status
      when 400
        raise Error, "Request is malformed. #{response.body["error"]}"
      when 401
        raise Error, "Invalid authentication credentials. #{response.body["error"]}"
      when 403
        raise Error, "Not allowed to perform that action. #{response.body["error"]}"
      when 404
        raise Error, "No results found for request. #{response.body["error"]}"
      when 429
        raise Error, "Request exceeded the API rate limit. #{response.body["error"]}"
      when 500
        raise Error, "Unable to perform the request due to server-side problems. #{response.body["error"]}"
      when 503
        raise Error, "Rate limited for sending too many requests. #{response.body["error"]}"
      end

      response
    end

    def refresh_authorization(response)
      @authorization = response.headers["Authorization"] if response.headers.key?("Authorization")
      response
    end

    def refresh_token(response)
      @token = response.headers["DSPACE-XSRF-TOKEN"] if response.headers.key?("DSPACE-XSRF-TOKEN")
      response
    end
  end
end
