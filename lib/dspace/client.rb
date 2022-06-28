# frozen_string_literal: true

require "faraday"
require "faraday-cookie_jar"
require "faraday_middleware"

require_relative "client/request" # TODO: refactor
require_relative "client/client"
require_relative "client/configuration"
require_relative "client/version"

# DSpace
module DSpace
  class ConfigurationError < StandardError; end
  class Error < StandardError; end
end
