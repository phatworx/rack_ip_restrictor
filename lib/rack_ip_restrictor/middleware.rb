# Rack middleware
class Rack::IpRestrictor::Middleware

  def initialize(app, options={})
    @app = app
    @options = options
  end

  # Rack middleware call method
  def call(env)
    remote_addr = IPAddr.new(env['REMOTE_ADDR'])

    Rack::IpRestrictor.config.restrictions.each do |restriction|
      return access_denied unless restriction.validate(env, remote_addr)
    end

    @app.call(env)
  end

  private
  # @return [Array] The response array [Status, set of headers, body]
  def access_denied
    Rack::IpRestrictor.config.response
  end
end
