defmodule Recipebook.Account do
  alias Recipebook.Account.{User, SavedRecipe, FollowingUser}
  alias Recipebook.Cookbook.Recipe
  alias Recipebook.Authentication
  alias EctoShorts.Actions
  @user_query User.setup_query()
  @saved_recipe_query SavedRecipe.setup_query()
  @cannot_find_user_tuple {:error, "Cannot find user"}
  def follow_user(user, %{id: id} = _params) do
    case find_user(%{id: id}) do
      {:ok, _followed_user} ->
        Actions.create(FollowingUser, %{user_id: user.id, following_user_id: id})
        {:ok, %{message: "Successfully followed user", followed_user: user.name}}
      {:error, _} -> @cannot_find_user_tuple
    end
  end
  def unfollow_user(user, %{id: id} = _params) do
    with {:ok, result} <- Actions.find(FollowingUser.setup_query(), %{following_user_id: id, user_id: user.id}),
          {:ok, _} = Actions.delete(result) do
      {:ok, %{message: "Succuessfully unfollow user"}}
    else
      {:error, _}  -> @cannot_find_user_tuple
    end
  end
  def all_users(params \\ %{}) do
    {search, params} = Map.split(params, [:name, :username])
    query = Enum.reduce(search, @user_query, &convert_field_to_query/2)
    {:ok, Actions.all(query, params)}
  end

  def get_followers(params) do
    case find_user(add_preload_in_params(params, [:followers])) do
      {:ok, user} -> {:ok, user.followers}
      {:error, _} -> {:error, "Cannot find user"}
    end
  end

  def get_following(params) do
    case find_user(add_preload_in_params(params, [:following])) do
      {:ok, user} ->  {:ok, user.following}
      {:error, _} -> @cannot_find_user_tuple
    end
  end

  defp convert_field_to_query({:name, value}, query) do
    User.by_name(query, value)
  end

  defp convert_field_to_query({:username, value}, query) do
    User.by_username(query, value)
  end

  def find_user(params \\ %{}) do
    Actions.find(@user_query, params)
  end

  def update_user(user, id, %{current_password: current_password} = params) do
    case Authentication.verify_user(%{username: user.username, password: current_password}) do
      {:ok, _user} -> if user.id === id do Actions.update(User, id, params) else {:error, "You do not have permission to change user details"} end
      {:error, reason} -> {:error, reason.message}
    end
  end

  def create_user(params) do
    Actions.create(User, params)
  end
  @spec get_saved_recipes(atom | %{id: any}) :: {:ok, any}
  def get_saved_recipes(user) do
    {:ok, Actions.all(@saved_recipe_query, %{user_id: user.id, preload: [:recipe]})}
  end

  def save_recipe(user, %{recipe_id: recipe_id} = _params) do
    with {:ok, recipe} <- Actions.find(Recipe.setup_query(), %{id: recipe_id}),
      {:ok, _} <-Actions.create(SavedRecipe, %{user: user, recipe: recipe})
    do
      {:ok ,recipe}
    else
      {:error, _} -> {:error, "user or recipe not found"}
    end
  end

  def unsave_recipe(user, %{recipe_id: recipe_id} = _params) do
    with {:ok, result} <- Actions.find(@saved_recipe_query, %{recipe_id: recipe_id, user_id: user.id}),
        {:ok, _} <- Actions.delete(result)
    do
      {:ok , %{message: "Successfully unsave a recipe"}}
    else
      {:error, reason}  -> {:error, reason.message}
    end
  end

  defp add_preload_in_params(params, keys) do
    Map.put(params, :preload, keys)
  end

end
