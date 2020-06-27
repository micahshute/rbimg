require "rbimg/version"
require 'require_all'
require 'byteman'
require 'zlib'
module Rbimg
  class Error < StandardError; end
  # Your code goes here...
end

require_all 'lib/errors'
require_relative './strategies/strategies'
require_all 'lib/strategies'
require_all 'lib/image_types'