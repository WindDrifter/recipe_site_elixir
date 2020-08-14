defmodule RecipebookWeb.Resolvers.Stat do
  alias Recipebook.Stats

  def all(%{is_category: is_category, top: top}, _) do
    Stats.get_stats(is_category, top)
  end

  def all(%{is_category: is_category}, _) do
    Stats.get_stats(is_category, 3)
  end

  def all(%{top: top}, _) do
    Stats.get_stats(top)
  end

  def all(params, _) when params == %{} do
    Stats.get_stats(3)
  end

  def find_by_categories(%{categories: categories}, _) do
    Stats.get_certain_categories_stats(categories)
  end

end
