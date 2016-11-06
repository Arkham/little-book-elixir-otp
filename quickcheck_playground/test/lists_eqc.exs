defmodule ListsEQC do
  use ExUnit.Case
  use EQC.ExUnit

  # inverse function
  property "reversing a list twice yields the original list" do
    forall l <- list(int) do
      ensure l |> Enum.reverse |> Enum.reverse == l
    end
  end

  property "encoding is the reverse of decoding" do
    forall bin <- binary do
      ensure bin |> Base.encode64 |> Base.decode64! == bin
    end
  end

  # exploit invariants
  def is_sorted([]), do: true
  def is_sorted(list) do
    list
    |> Enum.zip(tl(list))
    |> Enum.all?(fn {x, y} -> x <= y end)
  end

  property "sorting works" do
    forall l <- list(int) do
      ensure l |> Enum.sort |> is_sorted == true
    end
  end

  # use a simpler implementation
  defp map_store(k, v, list) do
    case find_index_with_key(k, list) do
      {:match, index} ->
        List.replace_at(list, index, {k, v})
        _ ->
          [{k, v} | list]
      end
  end

  defp find_index_with_key(k, list) do
    case Enum.find_index(list, fn({x,_}) -> x == k end) do
       nil -> :nomatch
       index -> {:match, index}
    end
  end

  property "storing keys and values" do
    forall {k, v, m} <- {key, val, map} do
      map_to_list = m |> Map.put(k, v) |> Map.to_list
      map_to_list == map_store(k, v, map_to_list)
    end
  end

  # perform operations in a different order
  property "appending an elem and sorting is the same as prepending and sorting" do
    forall {i, l} <- {int, list(int)} do
      [i|l] |> Enum.sort == l ++ [i] |> Enum.sort
    end
  end

  # idempotent operations
  property "calling Enum.uniq twice has no effect" do
    forall l <- list(int) do
      ensure l |> Enum.uniq == l |> Enum.uniq |> Enum.uniq
    end
  end

  # generators
  def map do
    map_gen = lazy do
      let {k, v, m} <- {key, val, map} do
        Map.put(m, k, v)
      end
    end

    oneof [Map.new, map_gen]
  end

  def key do
    oneof [int, real, atom]
  end

  def val do
    key
  end

  def atom do
    elements [:a, :b, :c, true, false, :ok]
  end
end
