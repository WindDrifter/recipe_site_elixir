defmodule RecipebookWeb.Schema.Queries.RecipeTest do
  use Recipebook.DataCase, async: true
  use ExUnit.Case, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Support.RecipeSupport
  alias Recipebook.Support.UserSupport

  @all_recipes_doc """
  query Recipes($ingredients: [String], $first: Int){
    recipes(ingredients: $ingredients, first: $first) {
      id
      name
    }
  }
  """
  @get_recipe_doc """
    query Recipe($id: ID, $name: String){
      recipe(id: $id, name: $name) {
        id
        name
        recipe_ingredients{
          name
        }
      }
    }
  """
  def setup_recipes(context) do
    assert {:ok, user} = UserSupport.generate_user()
    ingredient_names = RecipeSupport.generate_ingredients_name(5)
    ingredient_sets = RecipeSupport.create_ingredient_sets(ingredient_names)
    recipes = RecipeSupport.generate_recipes(user, ingredient_sets)
    output = %{recipes: recipes, user: user, ingredients: ingredient_names}
    Map.put(context, :output, output)
  end

  def setup_recipe(context) do
    assert {:ok, user} = UserSupport.generate_user()
    assert {:ok, recipe} = RecipeSupport.generate_recipe(user)
    Map.put(context, :recipe, recipe)
  end

  describe "@recipes" do
    setup [:setup_recipes]

    test "able to get recipes via ingredients", context do
      user = context[:output][:user]
      ingredients = context[:output][:ingredients]
      ingredient_names2 = RecipeSupport.generate_ingredients_name(7) -- ingredients
      ingredient_set_two = RecipeSupport.create_ingredient_sets(ingredient_names2)
      another_recipes = RecipeSupport.generate_recipes(user, ingredient_set_two)

      assert {:ok, %{data: data}} =
               Absinthe.run(@all_recipes_doc, Schema,
                 variables: %{
                   "ingredients" => ingredient_names2
                 }
               )

      assert length(data["recipes"]) === Enum.count(another_recipes)
    end

    test "able to get all recipes if no params supplied", context do
      recipes = context[:output][:recipes]
      assert {:ok, %{data: data}} = Absinthe.run(@all_recipes_doc, Schema, variables: %{})
      assert length(data["recipes"]) === Enum.count(recipes)
    end

    test "able to limit the amount of recipes", _context do
      assert {:ok, %{data: data}} =
               Absinthe.run(@all_recipes_doc, Schema, variables: %{"first" => 3})

      assert length(data["recipes"]) === 3
    end
  end

  describe "@recipe" do
    setup [:setup_recipe]

    test "able to get recipe via id", context do
      recipe = context[:recipe]

      assert {:ok, %{data: data}} =
               Absinthe.run(@get_recipe_doc, Schema,
                 variables: %{
                   "id" => recipe.id
                 }
               )

      assert data["recipe"]["name"] === recipe.name

      assert Enum.count(data["recipe"]["recipe_ingredients"]) ===
               Enum.count(recipe.recipe_ingredients)

      assert List.first(data["recipe"]["recipe_ingredients"])["name"]
    end

    test "return error when id doesn't exist", _context do
      assert {:ok, errors} =
               Absinthe.run(@get_recipe_doc, Schema,
                 variables: %{
                   "id" => "333333333"
                 }
               )

      assert Map.get(List.first(errors.errors), :message) =~ "Cannot find recipe"
    end
  end
end
