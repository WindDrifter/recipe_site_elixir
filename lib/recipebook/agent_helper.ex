defmodule Recipebook.AgentHelper do

  def get_top(state, amount \\ 3) do
    state
    |> Map.to_list
    |> Enum.sort(fn {_,y} , {_,b} -> y > b end)
    |> Enum.take(amount)
    |> Enum.map(fn {name, views} -> %{name: name, views: views} end)
  end

  def add_one(state, key) do
    Map.update(state, key, 1, fn current_value -> current_value + 1 end)
  end

end
