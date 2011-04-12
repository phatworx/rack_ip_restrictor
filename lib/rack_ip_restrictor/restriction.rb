module Rack::IpRestrictor
  class Restriction
    def initialize(*args)
      @options = args.extract_options!

      raise Exception, "invalid argument" unless @options.has_key? :only and @options[:only].is_a? Symbol

      @paths = args
      @paths.each do |path|
        raise Exception, "invalid path argument" unless path.is_a? String or path.is_a? Regexp
      end

    end

    def validate(env, remote_addr)
      @paths.each do |path|
        if concerns_path?(env["PATH_INFO"]) and not concerns_ip?(remote_addr)
          return false
        end
      end

      true
    end

    private

    def concerns_ip?(remote_addr)
      Rack::IpRestrictor.config.ips_for(@options[:only]).include?(remote_addr)
    end

    def concerns_path?(request_path)
      @paths.each do |path|
        return true if path.is_a? String and path == request_path
        return true if path.is_a? Regexp and path =~ request_path
      end
      false
    end
  end
end