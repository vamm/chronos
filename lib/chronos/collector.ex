defmodule Chronos.Collector do
  use GenServer

  def start_link(counters \\ %{}) do
    GenServer.start_link(__MODULE__, counters, name: __MODULE__)
  end

  def trace(func_name), do: GenServer.cast(__MODULE__, {:trace, func_name})
  def collect, do: GenServer.call(__MODULE__, :collect)
  def clear, do: GenServer.cast(__MODULE__, :clear)
  def inspect(func_name), do: GenServer.call(__MODULE__, {:inspect, func_name})

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call(:collect, _from, counters) do
    {:reply, counters, counters}
  end

  @impl true
  def handle_call({:inspect, func_name}, _from, counters) do
    current_counter = Map.get(counters, func_name)

    {:reply, current_counter, counters}
  end

  @impl true
  def handle_cast(:clear, _counters) do
    {:noreply, %{}}
  end

  @impl true
  def handle_cast({:trace, func_name}, counters) do
    current_counter = Map.get(counters, func_name, 0)
    updated_counters = Map.put(counters, func_name, current_counter + 1)

    {:noreply, updated_counters}
  end
end
