defmodule Alpha.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    _ = OpenTelemetry.register_application_tracer(:alpha)

    topologies = [
      example: [
        strategy: Cluster.Strategy.Epmd,
        config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
      ]
    ]

    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Alpha.DynamicSupervisor},
      {Cluster.Supervisor, [topologies, [name: Alpha.ClusterSupervisor]]},
      # Starts a worker by calling: Alpha.Worker.start_link(arg)
      # {Alpha.Stack, []},
      Alpha.HelloSupervisor
    ]

    Registry.start_link(keys: :unique, name: Alpha.HelloRegistry)
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Alpha.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
