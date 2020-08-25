defmodule Recipebook.Cookbook.RecipeIngredient do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges
  alias Recipebook.Cookbook.{Recipe, Ingredient}
  schema "recipe_ingredients" do
    field :amount, :integer
    field :unit, :string
    belongs_to :recipe, Recipe
    belongs_to :ingredient, Ingredient
    timestamps()
  end

  @required_params [:amount, :unit]
  @all_params @required_params
  def create_changeset(params) do
    changeset(%Recipebook.Cookbook.RecipeIngredient{}, params)
  end
  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, @all_params)
    |> CommonChanges.preload_changeset_assoc(:recipe)
    |> CommonChanges.preload_changeset_assoc(:ingredient)
    |> CommonChanges.put_or_cast_assoc(:recipe)
    |> CommonChanges.put_or_cast_assoc(:ingredient)
    |> validate_required(@required_params)
  end
end
