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

    # Must add context
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :email, :string
      arg :password, :string
    end

    field :follow_user, :user do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.follow_user/2
    end
  end

end
