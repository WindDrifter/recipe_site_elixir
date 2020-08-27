defmodule Recipebook.Cookbook.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset
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
    |> CommonChanges.preload_change_assoc(:recipe)
    |> CommonChanges.preload_change_assoc(:ingredient)
    |> validate_required(@required_params)
  end
end
