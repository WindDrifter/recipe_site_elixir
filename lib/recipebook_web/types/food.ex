defmodule RecipebookWeb.Types.Food do
  use Absinthe.Schema.Notation
  object :food do
    field :name, :string
    field :info, :string
  end

end
