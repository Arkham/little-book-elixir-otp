defmodule Blitzy do
  use Application

  def start(_, _) do
    Blitzy.Supervisor.start_link(:ok)
  end

  def run(n_workers, url) when n_workers > 0 do
    worker_fun = fn -> Blitzy.Worker.start(url) end

    1..n_workers
    |> Enum.map(fn _ -> Task.async(worker_fun) end)
    |> Enum.map(&Task.await(&1, :infinity))
  end
end
