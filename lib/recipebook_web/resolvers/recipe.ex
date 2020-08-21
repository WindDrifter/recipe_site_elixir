defmodule RecipebookWeb.Resolvers.Recipe do
  alias Recipebook.Account
  alias Recipebook.Cookbook
  def all(params, _) do
    Cookbook.all_recipes(params)
  end
  def find(%{id: id}, _) do
    id = String.to_integer(id)
    Cookbook.find_user(%{id: id})
  end

  def find(params, _) when params != %{} do
    Cookbook.find_user(params)
  end

  def find(params, _) when params == %{} do
    {:error, "must enter at least one params"}
  end

  def update_recipe(%{id: id} = params, _, %{context: %{current_user: current_user}}) do
    id = String.to_integer(id)
    Account.update_user(id, Map.delete(params, :id))
  end

  def create_recipe(params, _, %{context: %{current_user: current_user}}) do
    Cookbook.create_recipe(params, current_user)
  end

end
