# frozen_string_literal: true

require "faraday"
require "faraday-cookie_jar"
require "faraday_middleware"

require_relative "client/client"
require_relative "client/configuration"
require_relative "client/list"
require_relative "client/object"
require_relative "client/request"
require_relative "client/version"

require_relative "client/objects/collection"
require_relative "client/objects/community"
require_relative "client/objects/user"

require_relative "client/resources/authn"
require_relative "client/resources/collections"
require_relative "client/resources/communities"
require_relative "client/resources/users"

# DSpace
module DSpace
  class ConfigurationError < StandardError; end
  class Error < StandardError; end
  class InvalidParameterError < StandardError; end
end
