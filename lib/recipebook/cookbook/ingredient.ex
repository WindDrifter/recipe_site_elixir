defmodule Recipebook.Cookbook.Ingredient do
  use Ecto.Schema
  alias Recipebook.Cookbook.Ingredient
  import Ecto.Changeset
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges

  schema "ingredients" do
    field :info, :string
    field :name, :string
    field :wiki_url, :string

    # many_to_many :recipes, Recipebook.Cookbook.Recipe, join_through: Recipebook.Cookbook.RecipeIngredient
    has_many :recipe_ingredients, Recipebook.Cookbook.RecipeIngredient

    timestamps()
  end

  @required_params [:name]
  @all_params [:info, :wiki_url | @required_params]
  def create_changeset(params) do
    changeset(%Ingredient{}, params)
  end

  def setup_query() do
    from(i in Ingredient, as: :ingredient)
  end

  def join_with_recipe(query \\ setup_query()) do
    query
    |> join(:inner, [i], ri in assoc(i, :recipe_ingredients),
      on: i.id == ri.ingredient_id,
      as: :recipe_ingredients
    )
    # |> join(:inner, [recipe_ingredients: ri], r in assoc(ri, :recipe), as: :recipe)
    |> select([recipe_ingredients: ri], ri.recipe_id)
  end

  def search_by_name(ingredient_name, query) do
    search = "%#{ingredient_name}%"
    or_where(query, [i], ilike(i.name, ^search))
  end

  @doc false
  def changeset(ingredients, attrs) do
    ingredients
    |> cast(attrs, @all_params)
    |> validate_required(@required_params)
    |> CommonChanges.preload_change_assoc(:recipe_ingredients)
    |> unique_constraint(:name)
  end
end
