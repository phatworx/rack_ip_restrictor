require 'ipaddr'

module Rack
  class IpRestrictor
    DEFAULT_MESSAGE = %{
    <html>
    <head>
    <title>404</title>
    </head>
    <body>
    <h1>404</h1>
    <p>Muhaha, is it really 404?!</p>
    </body>
    </html>
    }

    def initialize(app,options={})
      @app = app
      @white_list = []

      if options[:white_list]
        options[:white_list].each do |ip|
          @white_list << IPAddr.new(ip)
        end
      end

      @response = [
        404,
        {'Content-Type' => (options[:content_type] || 'text/html')},
        [options[:message] || DEFAULT_MESSAGE]
      ]
    end

    def call(env)
      remote_addr = IPAddr.new(env['REMOTE_ADDR'])

      @white_list.each do |range|
        return @response unless range.include?(remote_addr)
      end

      @app.call(env)
    end
  end
end