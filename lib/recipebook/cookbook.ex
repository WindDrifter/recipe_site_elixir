defmodule Recipebook.Cookbook do
    alias Recipebook.Cookbook.{Recipe}
    alias EctoShorts.Actions
    import Argon2
    def all_recipes(params \\ %{}) do
      Actions.all(Recipe, params)
    end
    def find_recipe(params \\ %{}) do
      Actions.find(Recipe, params)
    end
  
    def update_recipe(id ,params) do
      Actions.update(Recipe, id, params)
    end
  
    def create_recipe(params) do
      Actions.create(Recipe, params)
    end
  
  
  end
  