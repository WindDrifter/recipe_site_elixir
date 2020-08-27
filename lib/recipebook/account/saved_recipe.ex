defmodule Recipebook.Account.SavedRecipe do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges
  alias Recipebook.Account.SavedRecipe
  schema "saved_recipes" do
    belongs_to :user, Recipebook.Account.User
    belongs_to :recipe, Recipebook.Cookbook.Recipe

    timestamps()
  end

  def create_changeset(params) do
    changeset(%SavedRecipe{}, params)
  end

  def setup_query() do
    from(sr in SavedRecipe, as: :saved_recipe)
  end
  @doc false
  def changeset(saved_recipe, attrs) do
    saved_recipe
    |> cast(attrs, [])
    |> validate_required([])
    |> CommonChanges.preload_change_assoc(:user)
    |> CommonChanges.preload_change_assoc(:recipe)
  end
end
