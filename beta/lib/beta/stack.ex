defmodule Beta.Stack do
  use GenServer

  # Callbacks

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

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
