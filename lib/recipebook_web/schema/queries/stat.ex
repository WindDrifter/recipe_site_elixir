defmodule RecipebookWeb.Schema.Queries.Stat do
  use Absinthe.Schema.Notation
  object :stat_queries do

    field :stats, list_of(:stat) do
      arg :is_category, :boolean
      arg :top, :integer
      resolve &RecipebookWeb.Resolvers.Stat.all/2
    end


    field :category_stats, list_of(:stat) do
      arg :categories, list_of(:string)
      resolve &RecipebookWeb.Resolvers.Stat.find_by_categories/2
    end
  end

end
