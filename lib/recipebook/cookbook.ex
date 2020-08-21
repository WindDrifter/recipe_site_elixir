defmodule Recipebook.Cookbook do
    alias Recipebook.Cookbook.{Recipe, Food, Ingredient}
    alias EctoShorts.{Actions, CommonFilters}
    import Argon2
    def all_recipes(params \\ %{}) do
      query =
      Recipe
      |> Recipe.join_with_ingredients()
      |> Recipe.join_with_user()
      {non_recipe_params, params} = Map.split(params, [:ingredients])
      query = Enum.reduce(non_recipe_params, query, &convert_field_to_query/2)
      {:ok, Actions.all(query, params)}
    end

    def find_recipe(params \\ %{}) do
      with {:ok, recipe} <- Actions.find(Recipe, params) do
        Recipebook.RecipeCounter.increment_by_one(recipe.name)
        Enum.map(recipe.categories, fn category -> add_recipe_category_stats(category) end)
        {:ok, recipe}
      else
        {_, _} ->
          {:error, "Cannot find recipe"}
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

    # defp convert_field_to_query({:chef_name, value}, query) do
    #   User.by_username(query, value)
    # end
    defp add_recipe_category_stats(category) do
      Recipebook.RecipeCounter.increment_by_one(CategoryCounter, category)
    end

    def update_recipe(id, params) do
      Actions.update(Recipe, id, params)
    end

    def create_recipe(params \\%{}, user) do
      ingredients = Map.get(params, :ingredients, [])
      Enum.map(ingredients, fn ingredient -> create_food(ingredient) end)
      params = params
      |> Map.put(:ingredients, ingredients)
      |> Map.put(:user, user)
      Actions.create(Recipe, params)
    end
    def create_food(%{name: name} = _params) do
      Actions.find_or_create(Food, %{name: name})
    end

  end
