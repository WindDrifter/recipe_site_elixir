defmodule RecipebookWeb.Types.Recipe do
  use Absinthe.Schema.Notation
  object :recipe do
    field :id, :id
    field :name, :string
    field :info, :string
    field :ingredients, list_of(:ingredient)
  end

  object :ingredient do
    field :food, :string
    field :quantity, :interger
  end

end
