defmodule RecipebookWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  object :user_mutations do

    @desc "Create an user/register an user"
    field :create_user, :user do
      arg :name, non_null(:string)
      arg :username, non_null(:string)
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &RecipebookWeb.Resolvers.User.create_user/2
    end

    field :login_user, :user_token do
      arg :username, :string
      arg :password, :string
      resolve &RecipebookWeb.Resolvers.User.login_user/2
    end

    # The mutations belows here require current_user context

    @desc "allow update of user info"
    field :update_user, :user do
      arg :id, non_null(:id)
      arg :name, :string
      arg :username, :string
      arg :email, :string
      arg :password, :string
      resolve &RecipebookWeb.Resolvers.User.update_user/2
    end

    @desc "Allow user to follow another user via user id, the current user is provided by context"
    field :follow_user, :followed_user do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.follow_user/2
    end

    @desc "Allow user to unfollow another user via user id, the current user is provided by context"
    field :unfollow_user, :followed_user do
      arg :id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.unfollow_user/2
    end

    # Why save recipe is in user area? Since it's user is the one that saving recipes
    # not recipe saving user.
    @desc "Allow user to save a recipe via recipe id, the current user is provided by context"
    field :save_recipe, :followed_recipe do
      arg :recipe_id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.save_recipe/2
    end

    @desc "Allow user to unsave a recipe via recipe id, the current user is provided by context"
    field :unsave_recipe, :followed_recipe do
      arg :recipe_id, non_null(:id)
      resolve &RecipebookWeb.Resolvers.User.unsave_recipe/2
    end
  end

end
