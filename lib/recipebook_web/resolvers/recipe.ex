defmodule RecipebookWeb.Resolvers.Recipe do
  alias Recipebook.Account
  alias Recipebook.Cookbook
  def all(params, _) do
    Cookbook.all_recipes(params)
  end
  def find(%{id: id}, _) do
    id = String.to_integer(id)
    Cookbook.find_recipe(%{id: id})
  end

  def find(params, _) when params != %{} do
    Cookbook.find_recipe(params)
  end

  def find(params, _) when params == %{} do
    {:error, "must enter at least one params"}
  end

  def update_recipe(_ ,%{id: id} = params, %{context: %{current_user: current_user}}) do
    id = String.to_integer(id)
    Cookbook.update_recipe(current_user, id, Map.delete(params, :id))
  end

  def create_recipe(_, params, %{context: %{current_user: current_user}}) do
    Cookbook.create_recipe(params, current_user)
  end

end
