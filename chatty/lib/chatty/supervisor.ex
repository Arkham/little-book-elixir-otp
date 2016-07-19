defmodule Chatty.Supervisor do
  use Supervisor

  @name :chatty_supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: @name)
  end

  def start_room(name) do
    Supervisor.start_child(@name, [name])
  end

  def init(_) do
    children = [
      worker(Chatty.Server, [])
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
