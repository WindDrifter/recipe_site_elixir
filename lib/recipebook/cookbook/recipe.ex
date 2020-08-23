defmodule Recipebook.Cookbook.Recipe do
  use Ecto.Schema
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges
  alias Recipebook.Cookbook.{Step, Ingredient}
  schema "recipes" do
    field :intro, :string
    field :name, :string
    field :total_views, :integer
    belongs_to :user, Recipebook.Account.User
    has_many :ingredients, Ingredient, on_replace: :delete
    has_many :steps, Step, on_replace: :delete
    field :categories, {:array, :string}, default: []
    timestamps()
  end


  @required_fields [:name]
  @available_fields [:intro, :total_views, :categories | @required_fields]

  def create_changeset(params) do
    changeset(%Recipebook.Cookbook.Recipe{}, params)
  end

  def by_name(name, query) do
    search = "%#{name}%"
    from(r in query, where: ilike(r.name, ^search))
  end

  def join_with_ingredients(query \\ Recipebook.Cookbook.Recipe) do
    join(query, :inner, [r], i in assoc(r, :ingredients), as: :ingredients)
  end
  def join_with_user(query \\ Recipebook.Cookbook.Recipe) do
    join(query, :inner, [r], u in assoc(r, :user), as: :user)
  end

  def search_by_chef_name(chef_name, query) do
    search = "%#{chef_name}%"
    where(query, [user: u], ilike(u.name, ^search))
  end

  def search_by_ingredient(ingredient, query) do
    search = "%#{ingredient}%"
    or_where(query, [ingredients: i], ilike(i.name, ^search))
  end
  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, @available_fields)
    |> CommonChanges.preload_changeset_assoc(:user, required: true)
    |> CommonChanges.preload_changeset_assoc(:ingredients, required: true)
    |> CommonChanges.preload_changeset_assoc(:steps, required: true)
    |> CommonChanges.put_or_cast_assoc(:user, required: true)
    |> CommonChanges.put_or_cast_assoc(:ingredients, required: true)
    |> CommonChanges.put_or_cast_assoc(:steps, required: true)
    |> validate_required(@required_fields)


  end
end
