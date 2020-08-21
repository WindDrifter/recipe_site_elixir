defmodule Recipebook.Cookbook.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :amount, :integer
    field :unit, :string
    field :name, :string
    belongs_to :recipe, Recipebook.Cookbook.Recipe
    timestamps()
  end

  @required_params [:name, :amount, :unit]
  @all_params @required_params
  def create_changeset(params) do
    changeset(%Recipebook.Cookbook.Ingredient{}, params)
  end
  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, @all_params)
    |> validate_required(@required_params)
  end
end
