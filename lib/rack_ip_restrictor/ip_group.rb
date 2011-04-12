module Rack::IpRestrictor
  # Stores and handles groups of IP's added as String, converted into hash of IpAddr
  class IpGroup

    def initialize
      @addresses = {}
    end

    # Adds an IP address to the list of addresses as instance of IPAddr
    #
    # @param [String] ip_arg IP address as String
    def add(ip_arg)
      @addresses[ip_arg] = IPAddr.new(ip_arg)
    end

    # @return [Array] Keys of addresses set
    def ips
      @addresses.keys
    end

    # @param [IpAddr] remote_addr The IP address of the requester
    def include?(remote_addr)
      @addresses.each do |key, value|
        return true if value.include? remote_addr
      end
      false
    end
  end
end