defmodule RecipebookWeb.Schema.Queries.StatTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  use ExUnit.Case, async: true
  alias Recipebook.RecipeCounter
  alias Recipebook.Support.StatSupport

  setup_all do
    categories = ["Chinese", "Japanese", "Italian", "Comfort food", "Fusion", "French"]
    Enum.map(categories, fn category -> RecipeCounter.increment_by_one(CategoryCounter, category) end)
    recipes = ["grill cheese", "Pizza", "Ramen", "Ice cream", "Roast duck", "Smoothie"]
    Enum.map(recipes, fn recipe -> RecipeCounter.increment_by_one(recipe) end)
    :ok
  end
  @get_stats_doc """
    query Stats($is_category: Boolean, $top: Int){
      stats(is_category: $is_category, top: $top) {
        name
        views
      }
    }
  """
  @get_category_stats_doc """
    query CategoryStats($categories: [String]) {
      category_stats(categories: $categories) {
        name
        views
      }
    }
  """


  describe "@stat" do
    test "Grab stat by category name" do
      StatSupport.increase_count(true, "Italian", 5)
      StatSupport.increase_count(true, "Chinese", 6)
      StatSupport.increase_count(true, "Japanese", 7)
      assert {:ok, %{data: data}} = Absinthe.run(@get_stats_doc, Schema,
        variables: %{"is_category"=> true, "top"=> 4}
      )
      assert is_list(data["stats"])
      assert Enum.count(data["stats"]) === 4
      assert Map.get(List.first(data["stats"]), "name") === "Japanese"
    end
    test "Grab stat by recipe name" do
      StatSupport.increase_count("Pizza", 5)
      StatSupport.increase_count("Smoothie", 6)
      StatSupport.increase_count("Ramen", 7)
      assert {:ok, %{data: data}} = Absinthe.run(@get_stats_doc, Schema,
        variables: %{"is_category"=> false, "top"=> 4}
      )
      assert is_list(data["stats"])
      assert Enum.count(data["stats"]) === 4
      assert Map.get(List.first(data["stats"]), "name") === "Ramen"
    end
  end
  describe "@categories_stats" do
    test "Grab stat by category name" do
      targeted_categories = ["Japanese", "Italian", "Comfort food"]
      assert {:ok, %{data: data}} = Absinthe.run(@get_category_stats_doc, Schema,
        variables: %{"categories" => targeted_categories}
      )
      categories_stats = data["category_stats"]
      assert is_list(categories_stats)
      assert Enum.count(categories_stats) === Enum.count(targeted_categories)
      assert Enum.count(Enum.reject(categories_stats, fn %{"name" => name} -> Enum.member?(targeted_categories, name) end)) === 0

    end
    test "Return empty list if none of categories found" do
      targeted_categories = ["Russian", "British", "Sweden"]
      assert {:ok, %{data: data}} = Absinthe.run(@get_category_stats_doc, Schema,
        variables: %{"categories" => targeted_categories}
      )
      categories_stats = data["category_stats"]
      assert is_list(categories_stats)
      assert Enum.count(categories_stats) === 0
    end
  end
end
