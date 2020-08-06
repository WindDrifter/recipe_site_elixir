defmodule Recipebook.Account do
  alias Recipebook.Account.{User, SavedRecipe}
  alias EctoShorts.Actions
  import Argon2
  
  def all_users(params \\ %{}) do
    Actions.all(User, params)
  end

  def login_user(params \\ %{}) do
    with {:ok, user} <- verify_user(params) do
      # generate jwt token here
      {:ok, user.id}
    else
      {:error, _} ->
        {:error, "wrong password or invalid username"}
    end
  end
  defp verify_user(%{password: input_password, username: input_username} = params) do

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
    |> Actions.delete()
  end


end
