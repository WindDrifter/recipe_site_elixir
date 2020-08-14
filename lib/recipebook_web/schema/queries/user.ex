defmodule RecipebookWeb.Schema.Queries.User do
  use Absinthe.Schema.Notation
  object :user_queries do

    field :user, :user do
      arg :id, :id
      arg :username, :string
      arg :name, :string
      resolve &RecipebookWeb.Resolvers.User.find/2
    end

    field :users, list_of(:user) do
      arg :username, :string
      arg :name, :string
      arg :first, :integer
      arg :limit, :integer
      resolve &RecipebookWeb.Resolvers.User.all/2
    end
  end

end
