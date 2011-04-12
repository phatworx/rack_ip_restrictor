module Rack::IpRestrictor
  # Configuration class for the IpRestrictor
  # @example
  #  Rack::IpRestrictor.configure do
  #    respond_with [403, {'Content-Type' => 'text/html'}, '']
  #
  #    ips_for :test do
  #      add '127.0.0.1'
  #      add '127.0.0.2/8'
  #    end
  #
  #    restrict /^\/admin/, '/admin', :only => :test
  #  end
  # @see README.rdoc
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

    # Overwrites the default response. Same format as a middleware response.
    #
    # @param [Array<Integer, String, String>] response status, a set of headers, body
    def respond_with(response)
      @response = response
    end

    # Sets and gets IP addresses for a named group
    #
    # @return [IpGroup] IP addresses for a named group
    def ips_for(name, &block)
      if block_given?
        @ip_groups[name] = IpGroup.new
        @ip_groups[name].instance_eval &block
        @ip_groups[name]
      else
        @ip_groups[name]
      end
    end

    # Adds a restriction
    # @see Restriction#initialize
    def restrict(*args)
      @restrictions << Restriction.new(*args)
    end

  end
end