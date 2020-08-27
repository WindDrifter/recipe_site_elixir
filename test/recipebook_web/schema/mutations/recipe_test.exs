defmodule RecipebookWeb.Schema.Mutations.RecipeTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Support.{RecipeSupport, UserSupport}
  alias Recipebook.Cookbook
  @create_recipe_doc """
    mutation CreateRecipe($name: String, $steps: [InputStep], $ingredients: [InputIngredient], $categories: [String]){
      createRecipe(name: $name, categories: $categories, steps: $steps, ingredients: $ingredients) {
        id
        name
        categories
      }
    }
  """
  @update_recipe_doc """
    mutation UpdateRecipe($id: ID, $name: String, $steps: [InputStep], $ingredients: [InputIngredient], $categories: [String]){
      updateRecipe(id: $id, name: $name, categories: $categories, steps: $steps, ingredients: $ingredients) {
        id
        name
        categories
      }
    }
  """

  def setup_user(context) do
    {:ok, user} = UserSupport.generate_user
    Map.put(context, :user, user)
  end


  # Absinthe.run(document, MyAppWeb.Schema, context: %{current_user: %{id: "1"}})
  # context: %{current_user: %{id: "1"}}

  describe "@createRecipe" do
    setup [:setup_user]
    test "able to create recipe", context do
      user = context[:user]
      raw_recipe = RecipeSupport.generate_raw_recipe()
      assert {:ok, %{data: data}} = Absinthe.run(@create_recipe_doc, Schema,
        [variables: raw_recipe, context: %{current_user: user}]
      )
      assert {:ok, found_user} = Cookbook.find_recipe(%{name: raw_recipe["name"]})
      assert found_user.categories === raw_recipe["categories"]
    end
    test "not able to create recipe if an important arg is missing", context do
      user = context[:user]
      raw_recipe = RecipeSupport.generate_raw_recipe()
      {_categories, raw_recipe} = Map.pop(raw_recipe, "categories")
      assert {:ok, %{errors: errors}} = Absinthe.run(@create_recipe_doc, Schema,
        [variables: raw_recipe, context: %{current_user: user}]
      )
      assert List.first(errors).message =~ "found null"
    end
  end
  describe "@updateRecipe" do
    setup [:setup_user]
    test "able to update recipe", context do
      user = context[:user]
      {:ok, old_recipe} = RecipeSupport.generate_recipe(user)
      old_recipe_id = old_recipe.id
      new_recipe = RecipeSupport.generate_raw_recipe()
      new_recipe = Map.put(new_recipe, "id", old_recipe_id)
      assert {:ok, %{data: data}} = Absinthe.run(@update_recipe_doc, Schema,
        [variables: new_recipe, context: %{current_user: user}]
      )
      assert {:ok, found_recipe} = Cookbook.find_recipe(%{id: old_recipe_id})
      assert found_recipe.name === new_recipe["name"]

      assert found_recipe.name !== old_recipe.name
    end
    test "not able to create recipe if an important arg is missing", context do
      user = context[:user]
      RecipeSupport.generate_recipe(user)
      new_recipe = RecipeSupport.generate_raw_recipe()
      assert {:ok, %{errors: errors}} = Absinthe.run(@update_recipe_doc, Schema,
        [variables: new_recipe, context: %{current_user: user}]
      )
      assert List.first(errors).message =~ "found null"
    end
  end
end
