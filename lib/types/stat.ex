defmodule RecipebookWeb.Types.Stat do
  use Absinthe.Schema.Notation
  object :stat do
    field :name, :string
    field :views, :integer
  end

end
