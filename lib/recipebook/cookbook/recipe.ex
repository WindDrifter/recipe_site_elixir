defmodule Recipebook.Cookbook.Recipe do
  use Ecto.Schema
  import Ecto.Changeset
  alias EctoShorts.CommonChanges
  schema "recipes" do
    field :intro, :string
    field :name, :string
    field :total_views, :integer
    belongs_to :user, Recipebook.Account.User
    has_many :ingredients, Recipebook.Cookbook.Ingredient
    has_many :steps, Recipebook.Cookbook.Step
    field :categories, {:array, :string}
    timestamps()
  end

  @required_fields [:name]
  @available_fields [:intro, :total_views | @required_fields]

  def create_changeset(params) do
    changeset(%Recipebook.Cookbook.Recipe{}, params)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @available_fields)
    |> validate_required(@required_fields)
    |> CommonChanges.preload_change_assoc(:user)
    |> CommonChanges.preload_change_assoc(:ingredients)
    |> CommonChanges.preload_change_assoc(:steps)

  end
end
