defmodule PingPong.Pinger do
  def loop do
    receive do
      {:start, receiver} ->
        send receiver, {:ping, self}
      {:pong, sender} ->
        IO.puts "#{inspect self}: Received Pong"
        :timer.sleep(1000)
        send sender, {:ping, self}
      _ ->
        IO.puts "I don't know what to do with this"
    end

    loop
  end
end
