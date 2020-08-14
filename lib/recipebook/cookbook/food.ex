defmodule Recipebook.Cookbook.Food do
  use Ecto.Schema
  import Ecto.Changeset

  schema "foods" do
    field :info, :string
    field :name, :string
    field :wiki_url, :string
    has_many :ingredients, Recipebook.Cookbook.Ingredient
    timestamps()
  end

  @required_params [:name]
  @all_params [:info, :wiki_url | @required_params]
  def create_changeset(params) do
    changeset(%Recipebook.Cookbook.Food{}, params)
  end
  @doc false
  def changeset(food, attrs) do
    food
    |> cast(attrs, @all_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
  end
end
