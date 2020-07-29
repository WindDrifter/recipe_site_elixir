defmodule Recipebook.Cookbook.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :info, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :info])
    |> validate_required([:name, :info])
    |> unique_constraint(:name)
  end
end
