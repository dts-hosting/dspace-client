# frozen_string_literal: true

module DSpace
  class Request
    attr_reader :client, :endpoint

    def initialize(client:, endpoint: nil)
      @client   = client
      @endpoint = endpoint
    end

    def all
      Enumerator.new do |yielder|
        records = list(page: 0)
        records.data.each { |d| yielder << d }
        while records.next_page
          records = list(page: records.next_page)
          records.data.each { |d| yielder << d }
        end
      end.lazy
    end

    def delete_request(path, params: {}, headers: {})
      response = client.connection.delete(path) do |req|
        handle_request(req, params: params, headers: headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def get_request(path, params: {}, headers: {})
      response = client.connection.get(path) do |req|
        handle_request(req, params: params, headers: headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def post_request(path, body:, params: {}, headers: {})
      response = client.connection.post(path) do |req|
        handle_request_with_payload(req, body: body, params: params, headers: headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    def put_request(path, body:, params: {}, headers: {})
      response = client.connection.patch(path) do |req|
        handle_request_with_payload(req, body: body, params: params, headers: headers)
      end
      refresh_token(response)
      handle_response(response)
    end

    private

    def handle_request(req, params:, headers:)
      req.params  = params
      req.headers = headers.merge({ "X-XSRF-Token" => client.token })
      req.headers["Authorization"] = client.authorization if client.authorization
    end

    def handle_request_for_authentication(req)
      req.body = URI.encode_www_form({ user: client.config.username, password: client.config.password })
      req.headers["Content-Type"] = "application/x-www-form-urlencoded"
      req.headers["X-XSRF-Token"] = client.token
    end

    def handle_request_with_payload(req, body:, params:, headers:)
      req.body    = body
      req.params  = params
      req.headers = headers.merge({ "Authorization" => client.authorization, "X-XSRF-Token" => client.token })
    end

    # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
    def handle_response(response)
      case response.status
      when 400
        raise Error, "Request is malformed. #{response.body["error"]}"
      when 401
        raise Error, "Invalid authentication credentials. #{response.body["error"]}"
      when 403
        raise Error, "Not allowed to perform the action. #{response.body["error"]}"
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
    # rubocop:enable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength

    def refresh_authorization(response)
      client.authorization = response.headers["Authorization"] if response.headers.key?("Authorization")
      response
    end

    def refresh_token(response)
      client.token = response.headers["DSPACE-XSRF-TOKEN"] if response.headers.key?("DSPACE-XSRF-TOKEN")
      response
    end

    # If the endpoint for the request has been initialized then treat the path as a fallback.
    # This is used by some resource methods to apply the endpoint for subrecords supplied by objects
    def resolve_endpoint(path)
      endpoint || path
    end
  end
end
