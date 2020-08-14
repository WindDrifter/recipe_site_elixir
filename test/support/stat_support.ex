defmodule Recipebook.Support.StatSupport do
  def increase_count(is_category\\false, key, count) do
    for _ <- 1..count do
      if is_category do
        Recipebook.RecipeCounter.increment_by_one(CategoryCounter, key)
      else
        Recipebook.RecipeCounter.increment_by_one(key)
      end

    end
  end
end
