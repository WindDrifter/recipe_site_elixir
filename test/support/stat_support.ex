defmodule Recipebook.Support.StatSupport do
  def increase_count(category?\\false, key, count) do
    for _ <- 1..count do
      if category? do
        Recipebook.RecipeViewCounter.increment_by_one(CategoryViewCounter, key)
      else
        Recipebook.RecipeViewCounter.increment_by_one(key)
      end

    end
  end
end
