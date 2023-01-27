defmodule RecipebookWeb.Types.Session do
  use Absinthe.Schema.Notation

  object :session do
    field :username, :string
    field :token, :string
  end
end
