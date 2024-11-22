# frozen_string_literal: true

module DSpace
  class Script < Object
    def run(parameters)
      DSpace::Process.new(
        client,
        DSpace::Request.new(client: client, endpoint: "system/scripts/#{name}/processes").post_request(
          body: parameters.to_json,
          headers: {"Content-Type": "multipart/form-data; boundary=#{multipart_boundary}"}
        ).body
      )
    end

    private

    def multipart_boundary
      "--------------------------" + (0...8).map { rand(65..90).chr }.join
    end
  end
end
