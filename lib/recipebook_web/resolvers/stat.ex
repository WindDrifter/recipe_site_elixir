defmodule RecipebookWeb.Resolvers.Stat do
  alias Recipebook.ViewStats.RecipeViewStats

  def all(%{is_category: category?, top: top}, _) do
    RecipeViewStats.get_stats(category?, top)
  end

  def all(%{is_category: category?}, _) do
    RecipeViewStats.get_stats(category?, 3)
  end

  def all(%{top: top}, _) do
    RecipeViewStats.get_stats(top)
  end

  def all(params, _) when params == %{} do
    RecipeViewStats.get_stats(3)
  end

  def find_by_categories(%{categories: categories}, _) do
    RecipeViewStats.get_certain_categories_stats(categories)
  end
end
