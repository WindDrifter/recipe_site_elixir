defmodule RecipebookWeb.Types.Recipe do
  use Absinthe.Schema.Notation

  import Absinthe.Resolution.Helpers, only: [dataloader: 2]

  object :recipe do
    field :id, :id
    field :name, :string
    field :info, :string
    field :categories, list_of(:string)

    field :recipe_ingredients, list_of(:recipe_ingredient),
      resolve: dataloader(Recipebook.Cookbook, :ingredients)

    field :user, :user
  end

  object :recipe_ingredient do
    field :id, :id
    field :name, :string
    field :unit, :string
    field :amount, :integer
  end

  object :step do
    field :id, :id
    field :number, :integer
    field :instruction, :string
  end

  input_object :input_ingredient do
    field :name, :string
    field :amount, :integer
    field :unit, :string
  end

  input_object :input_step do
    field :number, :integer
    field :instruction, :string
  end

  object :followed_recipe do
    field :message, :string
    field :id, :id
    field :name, :string
    field :info, :string
  end
end
