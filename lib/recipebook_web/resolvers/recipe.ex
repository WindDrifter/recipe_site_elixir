defmodule RecipebookWeb.Resolvers.Recipe do
  alias Recipebook.Cookbook
  def all(params, _) do
    Cookbook.all_recipes(params)
  end

  def find(params, _) when params == %{} do
    {:error, "must enter at least one params"}
  end

  def find(params, _) do
    Cookbook.find_recipe(serialized_params(params))
  end

  def update_recipe(params, %{context: %{current_user: current_user}}) do
    Cookbook.update_recipe(current_user, serialized_params(params))
  end

  @spec create_recipe(map, %{context: %{current_user: any}}) :: any
  def create_recipe(params, %{context: %{current_user: current_user}}) do
    Cookbook.create_recipe(params, current_user)
  end

  def create_recipe_topic(args, _) do
    {:ok, topic: args.user_ids }
  end

  defp serialized_params(%{id: id} = params) do
    Map.put(params, :id, String.to_integer(id))
  end

end
