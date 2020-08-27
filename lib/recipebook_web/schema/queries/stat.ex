defmodule RecipebookWeb.Schema.Queries.Stat do
  use Absinthe.Schema.Notation
  object :stat_queries do

    @desc """
    For checking stats.
    Order in desending order by default.
    There are 2 types of stats: Recipe name and recipe categories.
    If is_category is true then it will show only category stats.
    Otherwise it will show recipe name stats.
    Top is for limit the amount.
    IE top 3 will show the first 3 stat that have highest view count
    """
    field :stats, list_of(:stat) do
      arg :is_category, :boolean
      arg :top, :integer
      resolve &RecipebookWeb.Resolvers.Stat.all/2
    end

    @desc "For checking stats that within certain categories"
    field :category_stats, list_of(:stat) do
      arg :categories, list_of(:string)
      resolve &RecipebookWeb.Resolvers.Stat.find_by_categories/2
    end
  end

end
