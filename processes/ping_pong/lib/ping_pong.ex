defmodule PingPong do
  def start do
    pinger_pid = spawn(PingPong.Pinger, :loop, [])
    ponger_pid = spawn(PingPong.Ponger, :loop, [])
    IO.puts "Started Pinger: #{inspect pinger_pid}"
    IO.puts "Started Ponger: #{inspect ponger_pid}"
    send pinger_pid, {:start, ponger_pid}
  end
end
