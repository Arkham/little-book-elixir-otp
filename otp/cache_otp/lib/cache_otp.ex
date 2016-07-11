defmodule CacheOtp do
  use GenServer

  @name CacheOtp

  # Client API

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts ++ [name: @name])
  end

  def write(key, value) do
    GenServer.call(@name, {:write, key, value})
  end

  def read(key) do
    GenServer.call(@name, {:read, key})
  end

  def delete(key) do
    GenServer.call(@name, {:delete, key})
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def exists?(key) do
    GenServer.call(@name, {:exists?, key})
  end

  # Server API

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:write, key, value}, _from, state) do
    {:reply, :ok, Map.put(state, key, value)}
  end

  def handle_call({:read, key}, _from, state) do
    result = case Map.has_key?(state, key) do
      true -> Map.fetch(state, key)
      false -> :error
    end

    {:reply, result, state}
  end

  def handle_call({:delete, key}, _from, state) do
    case Map.has_key?(state, key) do
      true -> {:reply, :ok, Map.delete(state, key)}
      false -> {:reply, :error, state}
    end
  end

  def handle_call({:exists?, key}, _from, state) do
    {:reply, Map.has_key?(state, key), state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{}}
  end
end
