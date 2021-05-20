defmodule Beta.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    _ = OpenTelemetry.register_application_tracer(:beta)

    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: Beta.ClusterSupervisor]]},

      # Starts a worker by calling: Beta.Worker.start_link(arg)
      {Beta.Stack, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beta.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
