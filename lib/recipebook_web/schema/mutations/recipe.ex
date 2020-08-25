defmodule RecipebookWeb.Schema.Mutations.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_mutations do

    field :create_recipe, :recipe do
      arg :name, :string
      arg :ingredients, non_null(list_of(non_null(:input_ingredient)))
      arg :steps, non_null(list_of(non_null(:input_step)))
      arg :categories, non_null(list_of(non_null(:string)))
      resolve &RecipebookWeb.Resolvers.Recipe.create_recipe/2
    end

    field :update_recipe, :recipe do
      arg :id, non_null(:id)
      arg :name, :string
      arg :ingredients, list_of(non_null(:input_ingredient))
      arg :steps, list_of(non_null(:input_step))
      arg :categories, list_of(non_null(:string))
      resolve &RecipebookWeb.Resolvers.Recipe.update_recipe/2
    end
  end

end
