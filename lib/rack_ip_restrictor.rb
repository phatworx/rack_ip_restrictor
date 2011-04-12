require 'ipaddr'
require 'active_support/core_ext/array/extract_options'

# namespace Rack
module Rack
  # namespace IpRestrictor
  module IpRestrictor
    class << self
      attr_reader :config

      # @see Config#initialize
      def configure(&block)
        @config = IpRestrictor::Config.new
        @config.instance_eval &block
      end

      # Rack middleware
      # @return [Middleware] The configured plug & play Rack middleware
      def middleware
        IpRestrictor::Middleware
      end
    end
  end
end

require 'rack_ip_restrictor/ip_group'
require 'rack_ip_restrictor/middleware'
require 'rack_ip_restrictor/config'
require 'rack_ip_restrictor/restriction'

