defmodule Chatty.Server do
  use GenServer
  @name :chatty

  ## Api

  def start_link(name) do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def add_message(message) do
    GenServer.cast(@name, {:add_message, message})
  end

  def get_messages do
    GenServer.call(@name, :get_messages)
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
