defmodule Recipebook.Account do
  alias Recipebook.Account.{User, SavedRecipe}
  alias EctoShorts.Actions
  import Argon2

  def all_users(params \\ %{}) do
    {search, params} = Map.split(params, [:name, :username])
    query = Enum.reduce(search, User, &convert_field_to_query/2)
    {:ok, Actions.all(query, params)}
  end
  defp convert_field_to_query({:name, value}, query) do
    User.by_name(query, value)
  end

  defp convert_field_to_query({:username, value}, query) do
    User.by_username(query, value)
  end
  def login_user(params \\ %{}) do
    with {:ok, user} <- verify_user(params) do
      # generate jwt token here
      {:ok, user.id}
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

  def save_recipe(params) do
    Actions.create(SavedRecipe, params)
  end

  def unsave_recipe(params) do
    SavedRecipe
    |> Actions.find(params)
    |> Actions.delete
  end


end
