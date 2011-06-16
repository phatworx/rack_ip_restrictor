module Rack::IpRestrictor
  # Handles restrictions
  class Restriction

    # Inits a new restriction
    #
    # @example Path as String
    #   restrict '/admin', :only => :test
    # @example Path as Regexp
    #   restrict /^\/admin/, :only => :test
    # @example List of paths; Strings and Regexps can be combined
    #   restrict /^\/admin/, '/internal', '/secret', :only => :test
    #
    # @param [Array<String, Regexp, Hash>] *args
    #
    # @todo Add other options, i.e. an array of IP groups
    #   :only => [:test1, :admins]
    def initialize(*args)
      @options = args.extract_options!
      raise Exception, "invalid argument" if @options.has_key? :only and not @options[:only].is_a? Symbol

      @paths = args
      @paths.each do |path|
        raise Exception, "invalid path argument" unless path.is_a? String or path.is_a? Regexp
      end

    end

    # Validates, if a request (with a remote_address) is allowed to access the requested path
    # @see Middleware#call
    def validate(env, remote_addr)
      @paths.each do |path|
        if concerns_path?(env["PATH_INFO"]) and not concerns_ip?(remote_addr)
          return false
        end
      end

      true
    end

    private

    # @return [Boolean] Is the remote_addr included in a configured IP range?
    def concerns_ip?(remote_addr)
      Rack::IpRestrictor.config.ips_for(@options[:only]).include?(remote_addr)
    end

    # @return [Boolean] Does the request concern a configured path?
    def concerns_path?(request_path)
      @paths.each do |path|
        return true if path.is_a? String and path == request_path
        return true if path.is_a? Regexp and path =~ request_path
      end
      false
    end
  end
end
