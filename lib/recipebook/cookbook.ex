defmodule Recipebook.Cookbook do
  alias Recipebook.Cookbook.{Recipe, Ingredient}
  alias EctoShorts.{Actions}
  alias Recipebook.ViewStats.RecipeViewCounter

  @recipe_query Recipe.setup_query()
  def all_recipes(params \\ %{}) do
    {other_params, params} = Map.split(params, [:chef_name, :ingredients])
    query = Recipe.join_with_ingredients()
    query = Enum.reduce(other_params, query, &convert_field_to_query/2)

    {:ok, Actions.all(query, params)}
  end

  def find_recipe(params \\ %{}) do
    case Actions.find(@recipe_query, add_preload_in_params(params, [:user, :steps, :ingredients])) do
      {:ok, recipe} ->
      # I have to increase stats whenever a reciped id is called
      RecipeViewCounter.increment_by_one(recipe.name)
      Enum.map(recipe.categories, fn category -> add_recipe_category_stats(category) end)
      {:ok, recipe}
      {:error, _} -> {:error, "Cannot find recipe"}
    end
  end
  defp convert_field_to_query({:chef_name, value}, query) do
    Recipe.search_by_chef_name(value, query)
  end
  defp convert_field_to_query({:ingredients, value}, query) do
    Enum.reduce(value, query, &search_via_ingredient/2)
  end
  defp search_via_ingredient(value, query) do
    Recipe.search_by_ingredient(value, query)
  end

  defp add_recipe_category_stats(category) do
    RecipeViewCounter.increment_by_one(CategoryViewCounter, category)
  end

  def update_recipe(user, %{id: id} = params \\ %{}) do
    case Actions.find(@recipe_query, %{id: id, user_id: user.id}) do
      {:ok, _recipe} ->
      Actions.update(Recipe, id, seralizing_ingredients(params))
      {:error, _}  -> {:error, "Recipe do not exist or you do not have permission to edit it"}
    end
  end

  def create_recipe(params \\ %{}, user) do
    params = params
    |> seralizing_ingredients()
    |> Map.put(:user, user)
    Actions.create(Recipe, params)
  end

  defp create_recipe_ingredient_list(ingredients) do
    Enum.map(ingredients, fn ingredient -> create_or_find_ingredient(ingredient) end)
  end


  defp seralizing_ingredients(params) do
    {ingredients, params} = Map.pop(params, :ingredients, [])
    recipe_ingredients = create_recipe_ingredient_list(ingredients)
    Map.put(params, :recipe_ingredients, recipe_ingredients)
  end


  defp create_or_find_ingredient(%{name: name} = params) do
    case Actions.find_or_create(Ingredient, %{name: name}) do
      {:ok, ingredient} ->
        params
        |> Map.delete(:name)
        |> Map.put(:ingredient, ingredient)
      {:error, reason} -> {:error, reason}
    end
  end

  defp add_preload_in_params(params, keys) do
    Map.put(params, :preload, keys)
  end

end
