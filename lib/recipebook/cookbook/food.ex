defmodule Recipebook.Cookbook.Food do
  use Ecto.Schema
  import Ecto.Changeset

  schema "foods" do
    field :info, :string
    field :name, :string
    field :wiki_url, :string

    timestamps()
  end

  @doc false
  def changeset(food, attrs) do
    food
    |> cast(attrs, [:name, :info, :wiki_url])
    |> validate_required([:name, :info, :wiki_url])
    |> unique_constraint(:name)
  end
end
