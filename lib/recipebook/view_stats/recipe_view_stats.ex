defmodule Recipebook.ViewStats.RecipeViewStats do


  def get_stats(category? \\ false, top)
  def get_stats(false, top), do: Recipebook.ViewStats.RecipeViewCounter.get_top(top)
  def get_stats(true, top), do: Recipebook.ViewStats.RecipeViewCounter.get_top(CategoryViewCounter, top)


  def get_certain_categories_stats(categories \\ []) do
    case Recipebook.ViewStats.RecipeViewCounter.get_current_state(CategoryViewCounter) do
      {:ok, stats} ->
        result = Enum.reject(stats, fn {key, _value} -> !Enum.member?(categories, key) end)
        {:ok, Enum.map(result, fn {name, views} -> %{name: name, views: views} end)}
      {:error, message} -> {:error, message}
    end
  end
end
