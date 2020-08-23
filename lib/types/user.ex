defmodule RecipebookWeb.Types.User do
  use Absinthe.Schema.Notation
  object :user do
    field :id, :id
    field :username, :string
    field :name, :string
    field :email, :string
  end

  object :user_token do
    field :username, :string
    field :token, :string
  end

  object :followed_user do
    field :message, :string
    field :name, :string
    field :username, :string
  end

end
