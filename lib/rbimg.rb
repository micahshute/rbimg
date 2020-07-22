require_relative "./rbimg/version"
require 'byteman'
require 'zlib'
require 'pry'

module Rbimg
  class Error < StandardError; end
  # Your code goes here...
end

require_relative './errors/crc_error'
require_relative './errors/format_error'
require_relative './strategies/strategies'
require_relative './strategies/crc_strategies/crc_table_lookup_strategy'
require_relative './image_types/png'
