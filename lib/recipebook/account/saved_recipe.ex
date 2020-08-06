defmodule Recipebook.Account.SavedRecipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "saved_recipes" do
    belongs_to :user, Recipebook.Account.User
    belongs_to :recipe, Recipebook.Cookbook.Recipe

    timestamps()
  end

  @doc false
  def changeset(saved_recipe, attrs) do
    saved_recipe
    |> cast(attrs, [])
    |> validate_required([])
  end
end
