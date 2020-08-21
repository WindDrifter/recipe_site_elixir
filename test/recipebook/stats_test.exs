defmodule Recipebook.StatsTest do
  use ExUnit.Case, async: true
  alias Recipebook.RecipeCounter
  alias Recipebook.Stats
  alias Recipebook.Support.StatSupport
  @categories ["Chinese", "Japanese", "Italian", "Comfort food", "Fusion", "French"]
  @recipes ["grill cheese", "Pizza", "Ramen", "Ice cream"]

  setup_all do
    Enum.map(@categories, fn category -> RecipeCounter.increment_by_one(CategoryCounter, category) end)
    Enum.map(@recipes, fn recipe -> RecipeCounter.increment_by_one(recipe) end)
    :ok
  end
  describe "&get_stats/2" do
    test "able to get top 3 results" do
      assert {:ok, result} = Stats.get_stats(3)
      assert Enum.count(result) === 3
    end
    test "able to get results that is sorting by desending order" do
      StatSupport.increase_count("Pizza", 3)
      StatSupport.increase_count("Ice cream", 5)
      StatSupport.increase_count("Ramen", 9)
      assert {:ok, result} = Stats.get_stats(3)
      assert Enum.count(Enum.reject(result, fn %{name: name} -> Enum.member?(@recipes, name) end)) === 0
    end
    test "able to get Category results that is sorting by desending order" do
      StatSupport.increase_count(true, "Italian", 5)
      StatSupport.increase_count(true, "Chinese", 6)
      StatSupport.increase_count(true, "Japanese", 7)
      assert {:ok, result} = Stats.get_stats(true, 3)
      assert Enum.count(Enum.reject(result, fn %{name: name} -> Enum.member?(@categories, name) end)) === 0
    end
  end
  describe "&get_certain_categories_stats/1" do
    test "Able to get only certain category stats" do
      target_categories = ["Italian", "Comfort food", "Fusion", "French"]
      assert {:ok, result} = Stats.get_certain_categories_stats(target_categories)
      assert Enum.count(result) === 4
      assert Enum.count(Enum.reject(result, fn %{name: name} -> Enum.member?(target_categories, name) end)) === 0

    end
    test "Return empty map if none of categories exist" do
      assert {:ok, result} = Stats.get_certain_categories_stats(["Mongolian"])
      assert result === []
    end
  end
end