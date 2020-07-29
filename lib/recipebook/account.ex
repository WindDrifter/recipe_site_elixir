defmodule Recipebook.Account do
  alias Recipebook.Account.{User}
  alias EctoShorts.Actions

  def all_users(params \\ %{}) do
    Actions.all(params)
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

  def change_password(id, params) do

  end

end
