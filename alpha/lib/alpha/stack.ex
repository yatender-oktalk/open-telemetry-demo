defmodule Alpha.Stack do
  use GenServer

  require Logger
  # Callbacks

  def child_spec(opts) do
    name = Keyword.get(opts, :name, __MODULE__)

    %{
      id: "#{__MODULE__}_#name",
      start: {__MODULE__, :start_link, [name]},
      shutdown: 10_000,
      restart: :transient
    }
  end

  def start_link(name) do
    name = via_tuple(name)
    IO.inspect(name)

    case GenServer.start_link(__MODULE__, [], name: name) do
      {:ok, pid} ->
        {:ok, pid}

      {:error, {:already_started, pid}} ->
        Logger.info("already started at #{inspect(pid)}, returning :ignore")
        :ignore
    end
  end

  def via_tuple(name), do: {:via, Registry, {Alpha.HelloRegistry, name}}

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  @impl true
  def handle_call(:pop, from, [head | tail]) do
    IO.inspect(from)
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:state, from, state) do
    IO.inspect(from)
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
