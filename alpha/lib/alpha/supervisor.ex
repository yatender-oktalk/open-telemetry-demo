defmodule Alpha.UserSupervisor do
  @moduledoc """
  This is the supervisor for the worker processes you wish to distribute
  across the cluster, Swarm is primarily designed around the use case
  where you are dynamically creating many workers in response to events. It
  works with other use cases as well, but that's the ideal use case.
  """
  use DynamicSupervisor

  def start_link([]) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(args) do
    IO.inspect(args, label: "args")

    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Registers a new worker, and creates the worker process
  """
  def register(worker_name) do
    IO.inspect("register worker #{worker_name}")

    spec = %{
      id: worker_name,
      start: {Alpha.Worker, :start_link, [worker_name]},
      type: :worker
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
