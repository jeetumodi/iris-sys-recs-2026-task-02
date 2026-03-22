class PrometheusMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    status, headers, response = @app.call(env)

    HTTP_REQUESTS.increment(
      labels: {
        method: request.request_method,
        path: request.path,
        status: status.to_s
      }
    )

    [status, headers, response]
  end
end