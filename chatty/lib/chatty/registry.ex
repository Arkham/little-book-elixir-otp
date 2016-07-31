defmodule Chatty.Registry do
  use GenServer

  @name :chatty_registry

  ## API

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def whereis_name(room_name) do
    GenServer.call(@name, {:whereis_name, room_name})
  end

  def register_name(room_name, pid) do
    GenServer.call(@name, {:register_name, room_name, pid})
  end

  def unregister_name(room_name) do
    GenServer.cast(@name, {:unregister_name, room_name})
  end

  def send(room_name, message) do
    case whereis_name(room_name) do
      :undefined ->
        {:badarg, {room_name, message}}

      pid ->
        Kernel.send(pid, message)
        pid
    end
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:whereis_name, room_name}, _from, state) do
    {:reply, Map.get(state, room_name, :undefined), state}
  end

  def handle_call({:register_name, room_name, pid}, _from, state) do
    case Map.has_key?(state, room_name) do
      false ->
        Process.monitor(pid)
        {:reply, :yes, Map.put(state, room_name, pid)}
      true ->
        {:reply, :no, state}
    end
  end

  def handle_cast({:unregister_name, room_name}, state) do
    {:noreply, Map.delete(state, room_name)}
  end

  def handle_info({:DOWN, _, :process, pid, _}, state) do
    {:noreply, remove_pid(state, pid)}
  end

  def remove_pid(state, pid_to_remove) do
    remove = fn {_key, pid} -> pid != pid_to_remove end
    Enum.filter(state, remove) |> Enum.into(%{})
  end
end
