module Rack
  module IpRestrictor
    class RuleSet

      def initialize(middleware)
        @ip_groups = {}
        @middleware = middleware
      end

      def ip_group(name, &block)
        @ip_groups[name] = IpGroup.new
        @ip_groups[name].instance_eval &block
        @ip_groups[name]
      end
    end
  end
end