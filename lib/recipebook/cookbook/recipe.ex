defmodule Recipebook.Cookbook.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :intro, :string
    field :name, :string
    field :total_views, :integer
    belongs_to :user, Recipebook.Account.User
    has_many :ingredients, Recipebook.Cookbook.Ingredient
    has_many :steps, Recipebook.Cookbook.Step
    timestamps()
  end
  
  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :intro, :total_views])
    |> validate_required([:name, :intro, :total_views])
  end
end
