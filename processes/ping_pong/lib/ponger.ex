defmodule PingPong.Ponger do
  def loop do
    receive do
      {:ping, sender} ->
        IO.puts "#{inspect self}: Received Ping"
        :timer.sleep(1000)
        send sender, {:pong, self}
      _ ->
        IO.puts "I don't know what to do with this"
    end

    loop
  end
end
