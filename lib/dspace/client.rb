# frozen_string_literal: true

require "faraday"
require "faraday_middleware"

require_relative "client/services/login"

require_relative "client/client"
require_relative "client/configuration"
require_relative "client/error"
require_relative "client/version"

# DSpace
module DSpace
end
