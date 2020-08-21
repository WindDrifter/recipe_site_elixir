defmodule RecipebookWeb.Types.Recipe do
  use Absinthe.Schema.Notation
  object :recipe do
    field :id, :id
    field :name, :string
    field :info, :string
    field :ingredients, list_of(:ingredient)
    field :steps, list_of(:step)
    field :categories, list_of(:string)
  end

  object :ingredient do
    field :name, :string
    field :amount, :interger
    field :unit, :string
  end
  object :step do
    field :number, :integer
    field :description, :string
  end

end
