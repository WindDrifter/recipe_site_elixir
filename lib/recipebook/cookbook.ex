defmodule Recipebook.Cookbook do
    alias Recipebook.Cookbook.{Recipe, Ingredient}
    alias EctoShorts.{Actions}
    def all_recipes(params \\ %{}) do
      {other_params, params} = Map.split(params, [:chef_name, :ingredients])

      query = Recipe.join_with_ingredients(Recipe)
      query = Enum.reduce(other_params, query, &convert_field_to_query/2)

      {:ok, Actions.all(query, params)}
    end

    def find_recipe(params \\ %{}) do
      with {:ok, recipe} <- Actions.find(Recipe, params) do
        # I have to increase stats whenever a reciped id is called
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

    defp add_recipe_category_stats(category) do
      Recipebook.RecipeCounter.increment_by_one(CategoryCounter, category)
    end

    def update_recipe(user, id, params) do
      with {:ok, _recipe} <- Actions.find(Recipe, %{id: id, user_id: user.id}) do
        Actions.update(Recipe, id, params)
      else
        {_, _}  -> {:error, "Recipe do not exist or you do not have permission to edit it"}
      end
    end

    def create_recipe(params \\ %{}, user) do
      # IO.inspect(user)
      {ingredients, params} = Map.pop(params, :ingredients, [])
      recipe_ingredients = Enum.map(ingredients, fn ingredient -> create_ingredient(ingredient) end)
      params = params
      |> Map.put(:recipe_ingredients, recipe_ingredients)
      |> Map.put(:user, user)

      Actions.create(Recipe, params)
    end
    def create_ingredient(%{name: name} = params) do
      {:ok, ingredient} = Actions.find_or_create(Ingredient, %{name: name})
      params
      |> Map.delete(:name)
      |> Map.put(:ingredient, ingredient)

    end

  end
