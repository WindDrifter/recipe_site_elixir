defmodule Recipebook.Support.StatSupport do
  alias Recipebook.ViewStats.RecipeViewCounter

  def increase_count(category? \\ false, key, count) do
    for _ <- 1..count do
      if category? do
        RecipeViewCounter.increment_by_one(CategoryViewCounter, key)
      else
        RecipeViewCounter.increment_by_one(key)
      end
    end
  end
end
