defmodule Recipebook.CookbookTest do
    use Recipebook.DataCase, async: true
    alias Recipebook.Support.UserSupport
    alias Recipebook.Support.RecipeSupport

    alias Recipebook.Cookbook

    def setup_user(context) do
      {_, user} = UserSupport.generate_user
      Map.put(context, :user, user)
    end

    def setup_recipes(context) do
      assert {:ok, user} = UserSupport.generate_user
      ingredient_names = RecipeSupport.generate_ingredients_name(5)
      ingredient_sets = RecipeSupport.create_ingredient_sets(ingredient_names)
      recipes = RecipeSupport.generate_recipes(user, ingredient_sets)
      output = %{recipes: recipes, user: user, ingredients: ingredient_names}
      Map.put(context, :output, output)
    end

    def setup_recipe(context) do
      assert {:ok, user} = UserSupport.generate_user
      assert {:ok, recipe} = RecipeSupport.generate_recipe(user)
      Map.put(context, :recipe, recipe)
    end

    describe "&create recipe/2" do
      setup [:setup_user]
      test "able to create recipe" , context do
        user = context[:user]
        new_recipe = %{name: "test bacon recipes", steps: [
        %{
          number: 1,
          instruction: "heat up pan"
        },
        %{number: 2, instruction: "open bacon packages"}
        ],
        categories: ["comfort food", "breakfast"],
        ingredients: [%{name: "bacon", amount: 5, unit: "strips"}, %{name: "oil", amount: 10, unit: "ml"}]
        }
        assert {:ok, _} = Cookbook.create_recipe(new_recipe, user)
        assert recipe = Recipebook.Repo.get_by(Cookbook.Recipe, name: "test bacon recipes")
        assert recipe.name === new_recipe[:name]
        assert recipe.categories === new_recipe[:categories]
      end

      test "not able to create recipe if parameters missing" , context do
        user = context[:user]
        new_recipe = %{name: "test bacon recipes"}
        assert {:error, _} = Cookbook.create_recipe(new_recipe, user)
      end

    end

    describe "&find_recipe/1" do
      setup [:setup_recipe]

      test "able to find recipe", context do
        recipe = context[:recipe]
        assert {:ok, result} = Cookbook.find_recipe(%{id: recipe.id})
        assert result.name === recipe.name
      end

      test "return error no recipe found", _context do
        assert {:error, _} = Cookbook.find_recipe(%{name: "This is an non existance recipe"})
      end

    end
    describe "&all_recipes/1" do
      setup [:setup_recipes]

      test "get all recipes ", context do
        recipes = context[:output].recipes
        {_, user} = UserSupport.generate_user
        # generate more recipes for testing
        other_recipes_set = RecipeSupport.generate_recipes(user)
        assert {:ok, returned_recipes} = Cookbook.all_recipes()
        assert Enum.count(returned_recipes) === (Enum.count(recipes) + Enum.count(other_recipes_set))
      end

      test "get all recipe based on chef's name", context do
        recipes = context[:output].recipes
        {:ok, other_chef} = UserSupport.generate_user
        other_recipes = RecipeSupport.generate_recipes(other_chef, RecipeSupport.generate_ingredients, 10)
        assert {:ok, returned_recipes} = Cookbook.all_recipes(%{chef_name: other_chef.name})
        assert Enum.count(other_recipes) === Enum.count(returned_recipes)
        assert Enum.count(recipes) !== Enum.count(returned_recipes)
      end

      test "get all recipe based on ingredients", context do
        ingredients = context[:output].ingredients
        user = context[:output].user
        ingredient_names2 = RecipeSupport.generate_ingredients_name(5) -- ingredients
        ingredient_set_two = RecipeSupport.create_ingredient_sets(ingredient_names2)
        recipes = RecipeSupport.generate_recipes(user, ingredient_set_two)
        assert {:ok, returned_recipes} = Cookbook.all_recipes(%{ingredients: ingredient_names2})
        assert Enum.count(returned_recipes) === Enum.count(recipes)
      end

      test "get first n recipe", _context do
        assert {:ok, returned_recipes} = Cookbook.all_recipes(%{first: 2})
        assert Enum.count(returned_recipes) === 2
      end

    end
    describe "&update_recipe/1" do
      setup [:setup_user]

      test "able to find recipe", context do
        user = context[:user]
        {:ok, recipe} = RecipeSupport.generate_recipe(user)
        new_recipe = RecipeSupport.generate_raw_recipe()
        assert {:ok, result} = Cookbook.update_recipe(user, recipe.id, new_recipe)
        assert result.name === new_recipe["name"]
      end

      test "return error if try to edit someone else's recipe", context do
        user = context[:user]
        {:ok, another_user} = UserSupport.generate_user
        {:ok, recipe} = RecipeSupport.generate_recipe(another_user)
        new_recipe = RecipeSupport.generate_raw_recipe()
        assert {:error, message} = Cookbook.update_recipe(user, recipe.id, new_recipe)
        assert message =~ "do not exist"
      end

    end

  end
