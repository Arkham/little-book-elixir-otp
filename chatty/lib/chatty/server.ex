defmodule Chatty.Server do
  use GenServer

  ## Api

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: via_tuple(name))
  end

  def add_message(room_name, message) do
    GenServer.cast(via_tuple(room_name), {:add_message, message})
  end

  def get_messages(room_name) do
    GenServer.call(via_tuple(room_name), :get_messages)
  end

  def via_tuple(room_name) do
    # {:via, Chatty.Registry, {:chat_room, room_name}}
    {:via, :gproc, {:n, :l, {:chat_room, room_name}}}
  end

  ## Callbacks

  def init(messages) do
    {:ok, messages}
  end

  def handle_cast({:add_message, message}, state) do
    {:noreply, [message|state]}
  end

  def handle_call(:get_messages, _from, state) do
    {:reply, state, state}
  end
end
