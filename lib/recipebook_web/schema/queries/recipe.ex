defmodule RecipebookWeb.Schema.Queries.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_queries do

    field :recipe, :recipe do
      arg :id, :id
      arg :name, :string
      resolve &RecipebookWeb.Resolvers.Recipe.find/2
    end

    field :recipes, list_of(:recipe) do
      arg :name, :string
      arg :ingredients, list_of(:string)
      arg :categories, list_of(:string)
      arg :first, :integer
      arg :after, :id
      resolve &RecipebookWeb.Resolvers.Recipe.all/2
    end
  end

end
