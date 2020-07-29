defmodule Recipebook.Cookbook.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :amount, :integer
    field :unit, :string
    belongs_to :food, Recipebook.Cookbook.Food

    belongs_to :recipe, Recipebook.Cookbook.Recipe

    timestamps()
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:amount, :unit])
    |> validate_required([:amount, :unit])
  end
end
