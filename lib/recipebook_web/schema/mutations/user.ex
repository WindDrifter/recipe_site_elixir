defmodule RecipebookWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  object :user_mutations do

    field :create_user, :user do
      arg :name, non_null(:string)
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &RecipebookWeb.Resolvers.User.create_user/2
    end

    field :update_user, :user do
      arg :id, :id
      arg :name, :string
    end
  end

end
