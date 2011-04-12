module Rack::IpRestrictor
  class Config
    attr_accessor :response, :ip_groups, :restrictions

    def initialize
      @ip_groups = {}
      @restrictions = []
      @response = [
        403,
        {'Content-Type' => 'text/html'},
        ''
      ]
    end

    def respond_with(response)
      @response = response
    end

    def ips_for(name, &block)
      if block_given?
        @ip_groups[name] = IpGroup.new
        @ip_groups[name].instance_eval &block
        @ip_groups[name]
      else
        @ip_groups[name]
      end
    end

    def restrict(*args)
      @restrictions << Restriction.new(*args)
    end

  end
end