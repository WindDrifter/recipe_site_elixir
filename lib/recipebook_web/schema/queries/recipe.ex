defmodule RecipebookWeb.Schema.Queries.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_queries do

    field :recipe, :recipe do
      arg :id, :id
      arg :name, :string
    end

    field :recipes, list_of(:recipe) do
      arg :name, :string

    end
  end

end
