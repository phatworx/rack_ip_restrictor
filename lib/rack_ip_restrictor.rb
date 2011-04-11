require 'ipaddr'
require 'active_support/core_ext/array/extract_options'

# namespace rack
module Rack
  module IpRestrictor
    class << self
      def configure(&block)
        @config = IpRestrictor::Config.new
        @config.instance_eval &block
      end

      def config
        @config
      end

      def middleware
        IpRestrictor::Middleware
      end
    end
  end
end

require 'rack_ip_restrictor/ip_group'
require 'rack_ip_restrictor/rule_set'
require 'rack_ip_restrictor/middleware'
require 'rack_ip_restrictor/config'

