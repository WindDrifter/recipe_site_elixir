defmodule RecipebookWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  object :user_queries do

    field :user, :user do
      arg :id, :id
      arg :username, :string
    end

    field :users, list_of(:user) do
      arg :username, :string
      arg :email, :string
      arg :first_name, :string
      arg :last_name, :string
    end
  end

end
