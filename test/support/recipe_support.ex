defmodule Recipebook.Support.RecipeSupport do
  alias Recipebook.Cookbook

  # using_same_ingredients is for how many recipes are using the same
  # ingredient
  # for example if I put in 4. 4 of the recipes will use at least one same
  # ingredient name.
  def generate_recipes(user, ingredients \\ generate_ingredients(), max \\ 4) do
    for n <- 1..max do
      {:ok, _} =
        Cookbook.create_recipe(
          %{
            name: "recipe #{n}",
            ingredients: ingredients,
            categories: ["comfort food", "breakfast"],
            steps: generate_steps()
          },
          user
        )
    end
  end

  def generate_recipe(user) do
    params = %{
      name: Faker.Food.dish(),
      ingredients: generate_ingredients(),
      categories: ["comfort food", "breakfast"],
      steps: generate_steps()
    }

    Cookbook.create_recipe(params, user)
  end

  def generate_raw_recipe do
    %{
      "name" => Faker.Food.dish(),
      "ingredients" => generate_graphql_ingredients(5),
      "categories" => ["comfort food", "breakfast"],
      "steps" => generate_graphql_steps()
    }
  end

  def generate_ingredients_name(max \\ 4) do
    for _n <- 1..max, do: Faker.Food.ingredient()
  end

  def create_ingredient_sets(ingredients) do
    Enum.map(ingredients, fn ingredient ->
      %{name: ingredient, unit: Faker.Food.measurement(), amount: 100}
    end)
  end

  def generate_ingredients(max \\ 4) do
    ingredients =
      for _n <- 1..max do
        %{
          name: Faker.Food.ingredient(),
          unit: Faker.Food.measurement(),
          amount: Enum.random(0..100)
        }
      end

    ingredients
  end

  def generate_graphql_ingredients(max \\ 4) do
    ingredients =
      for _n <- 1..max do
        %{"name" => Faker.Food.ingredient(), "unit" => Faker.Food.measurement(), "amount" => 100}
      end

    ingredients
  end

  def generate_steps(max \\ 5) do
    steps =
      for n <- 1..max do
        %{number: n, instruction: "do this #{n}"}
      end

    steps
  end

  defp generate_graphql_steps(max \\ 5) do
    steps =
      for n <- 1..max do
        %{"number" => n, "instruction" => "do this #{n}"}
      end

    steps
  end
end
