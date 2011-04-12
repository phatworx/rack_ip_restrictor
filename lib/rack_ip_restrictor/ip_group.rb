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

      def include?(remote_addr)
        @addresses.each do |key, value|
          return true if value.include? remote_addr
        end
        false
      end
    end
  end
end