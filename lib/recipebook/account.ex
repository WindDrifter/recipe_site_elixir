defmodule Recipebook.Account do
  alias Recipebook.Account.{User, SavedRecipe, FollowingUser}
  alias Recipebook.Cookbook.Recipe

  alias EctoShorts.Actions
  import Argon2
  import Ecto.{Changeset, Query}

  def follow_user(user, id) do
    with {:ok, followed_user} <- find_user(%{id: id}) do
      Actions.create(FollowingUser, %{user_id: user.id, following_user_id: id})
    else
      {_, _} -> {:error, "User does not exist"}
    end
  end

  def all_users(params \\ %{}) do
    {search, params} = Map.split(params, [:name, :username])
    query = Enum.reduce(search, User, &convert_field_to_query/2)
    {:ok, Actions.all(query, params)}
  end

  def get_followers(%{id: id} = params) do
    query = User
    |> User.join_other_users_as_followers()
    |> User.find_user_followers(id)
    {:ok, Actions.all(query, %{})}
  end

  def get_following(params) do
    query = preload(User, [:users])
    with {:ok, user} <- Actions.find(query, params) do
      {:ok, user.users}
    else
      {_, _} -> {:error, "User not found"}
    end
  end

  defp convert_field_to_query({:name, value}, query) do
    User.by_name(query, value)
  end

  defp convert_field_to_query({:username, value}, query) do
    User.by_username(query, value)
  end
  def login_user(params \\ %{}) do
    with {:ok, user} <- verify_user(params),
         {:ok, jwt, _} <- Recipebook.Account.Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt}}
    else
      {_, _} ->
        {:error, "wrong password or invalid username"}
    end
  end
  defp verify_user(%{password: input_password, username: input_username} = _params) do

    {:ok, user} = Actions.find(User, %{username: input_username})
    check_pass(user, input_password, hash_key: :password)
  end

  def find_user(params \\ %{}) do
    Actions.find(User, params)
  end

  def update_user(id ,params) do
    Actions.update(User, id, params)
  end

  def create_user(params) do
    Actions.create(User, params)
  end
  def get_saved_recipes(user) do
    query = preload(SavedRecipe, :recipe)
    {:ok, Actions.all(query, %{user_id: user.id})}
  end

  def save_recipe(user, %{recipe_id: recipe_id} = _params) do
    with {:ok, recipe} <- Actions.find(Recipe, %{id: recipe_id}) do
        Actions.create(SavedRecipe, %{user: user, recipe: recipe})
    else
      {_, _} -> {:error, "user or recipe not found"}

    end
  end

  def unsave_recipe(user, %{recipe_id: recipe_id} = _params) do
    with {:ok, result} <- Actions.find(SavedRecipe, %{recipe_id: recipe_id, user_id: user.id}) do
      Actions.delete(result)
    else
      {_, _}  -> {:error, "Recipe/User not found. Or recipe already unsaved"}
    end
  end


end
