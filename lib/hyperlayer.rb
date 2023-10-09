require "hyperlayer/version"
require "hyperlayer/engine"

require 'json'
require 'redis'
require 'hashie'
require 'pry'
require 'hyperlayer/method_tracer'
require 'hyperlayer/tracer'

module Hyperlayer
  def self.trace_rspec!
    Tracer.trace_rspec!
  end
end
