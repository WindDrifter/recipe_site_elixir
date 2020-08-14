defmodule RecipebookWeb.Types.Recipe do
  use Absinthe.Schema.Notation
  object :recipe do
    field :id, :id
    field :name, :string
    field :info, :string
    field :ingredients, list_of(non_null(:ingredient))
    field :steps, list_of(non_null(:step))
    field :categories, list_of(:string)

  end

  input_object :ingredient do
    field :food_name, :string
    field :amount, :interger
    field :unit, :string
  end
  input_object :step do
    field :number, :integer
    field :description, :string
  end

end
