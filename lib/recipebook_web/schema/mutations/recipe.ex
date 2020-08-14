defmodule RecipebookWeb.Schema.Mutations.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_mutations do

    field :recipe_creation, :recipe do
      arg :name, :string
      arg :ingredients, list_of(:ingredient)
      arg :steps, list_of(:step)
      arg :category, list_of(:string)
    end

    field :update_recipe, :recipe do
      arg :id, :id
      arg :name, :string
      arg :ingredients, list_of(:ingredient)
      arg :steps, list_of(:step)
      arg :category, list_of(:string)
    end
  end

end
