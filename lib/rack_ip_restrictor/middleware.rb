class Rack::IpRestrictor::Middleware

  def initialize(app, options={})
    @app = app
    @options = options
#        @response = [
#          404,
#          {'Content-Type' => (options[:content_type] || 'text/html')},
#          [options[:message] || DEFAULT_MESSAGE]
#        ]
  end

  def call(env)
    remote_addr = IPAddr.new(env['REMOTE_ADDR'])

    Rack::IpRestrictor.config.restrictions.each do |restriction|
      return access_denied unless restriction.validate(env, remote_addr)
    end

    @app.call(env)
  end

  def access_denied
    Rack::IpRestrictor.config.response
  end
end
