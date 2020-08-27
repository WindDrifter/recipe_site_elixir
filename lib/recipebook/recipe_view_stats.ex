defmodule Recipebook.RecipeViewStats do


  def get_stats(category? \\ false, top) do
    if category? do
      Recipebook.RecipeViewCounter.get_top(CategoryViewCounter, top)
    else
      Recipebook.RecipeViewCounter.get_top(top)
    end
  end

  def get_certain_categories_stats(categories \\ []) do
    {:ok, stats} = Recipebook.RecipeViewCounter.get_current_state(CategoryViewCounter)
    result = Enum.reject(stats, fn {key, _value} -> !Enum.member?(categories, key) end)
    {:ok, Enum.map(result, fn {name, views} -> %{name: name, views: views} end)}
  end

end
