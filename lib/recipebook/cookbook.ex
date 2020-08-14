defmodule Recipebook.Cookbook do
    alias Recipebook.Cookbook.{Recipe, Food, Ingredient}
    alias EctoShorts.Actions
    import Argon2
    def all_recipes(params \\ %{}) do
      Actions.all(Recipe, params)
    end
    def find_recipe(params \\ %{}) do
      {_, recipe} = Actions.find(Recipe, params)
      Recipebook.RecipeCounter.increment_by_one(recipe.name)
      Enum.map(recipe.categories, fn category -> add_recipe_category_stats(category) end)
      {:ok, recipe}
    end

    defp add_recipe_category_stats(category) do
      Recipebook.RecipeCounter.increment_by_one(CategoryCounter, category)
    end

    def update_recipe(id ,params) do
      Actions.update(Recipe, id, params)
    end

    def create_recipe(params) do
      %{ingredients: ingredients} = params
      ingredients = Enum.map(ingredients, fn ingredient -> create_ingredient(ingredient) end)
      Map.put(params, :ingredients, ingredients)

      Actions.create(Recipe, params)
    end

    def create_ingredient(%{name: name} = params) do
      {_, food} = Actions.find_or_create(Food, %{name: name})
      {_, output} = Map.pop(params, :name)
      Map.put(output, :food_id, food.id)
    end

  end
