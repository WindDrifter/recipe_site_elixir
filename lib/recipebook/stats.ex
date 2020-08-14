defmodule Recipebook.Stats do


  def get_stats(is_category \\ false, top) do
    if is_category do
      Recipebook.RecipeCounter.get_top(CategoryCounter, top)
    else
      Recipebook.RecipeCounter.get_top(top)
    end
  end

  def get_certain_categories_stats(categories \\ []) do
    {_, stats} = Recipebook.RecipeCounter.get_current_state(CategoryCounter)
    {result, _} = Map.split(stats, categories)
    {:ok, Enum.map(result, fn {name, views} -> %{name: name, views: views} end)}
  end

end
