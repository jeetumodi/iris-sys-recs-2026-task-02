require 'prometheus/client'

# global registry
PROMETHEUS = Prometheus::Client.registry

# create counter
HTTP_REQUESTS = PROMETHEUS.counter(
  :http_requests_total,
  docstring: 'Total HTTP Requests',
  labels: [:method, :path, :status]
)