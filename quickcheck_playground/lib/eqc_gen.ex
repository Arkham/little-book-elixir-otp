defmodule EQCGen do
  use EQC.ExUnit

  def string_with_fixed_length(len) do
    vector(len, char)
  end

  def string_with_variable_length do
    let len <- choose(1, 10) do
      vector(len, oneof(:lists.seq(?a, ?z)))
    end
  end

  def string_with_commas do
    let len <- choose(1, 10) do
      vector(len, frequency([{3, oneof(:lists.seq(?a, ?z))},
         {1, ?,}]))
    end
  end
end
