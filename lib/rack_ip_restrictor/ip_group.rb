module Rack
  module IpRestrictor
    class IpGroup

      def initialize
        @addresses = {}
      end

      def add(ip_arg)
        @addresses[ip_arg] = IPAddr.new(ip_arg)
      end

      def ips
        @addresses.keys
      end
    end
  end
end