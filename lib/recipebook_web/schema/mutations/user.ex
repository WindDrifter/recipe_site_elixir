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
      arg :username, :string
      arg :email, :string
      arg :password, :string
      resolve &RecipebookWeb.Resolvers.User.update_user/2
    end

    field :login_user, :user_token do
      arg :username, :string
      arg :password, :string
      resolve &RecipebookWeb.Resolvers.User.login_user/2
    end

    field :follow_user, :followed_user do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.follow_user/2
    end

    field :unfollow_user, :followed_user do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.unfollow_user/2
    end

    field :save_recipe, :recipe do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.save_recipe/2
    end
  end

end
