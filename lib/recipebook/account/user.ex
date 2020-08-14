defmodule Recipebook.Account.User do
  import Argon2
  import Ecto.Changeset
  import Ecto.Query
  use Ecto.Schema
  alias EctoShorts.CommonChanges
  alias Recipebook.Repo
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :username, :string
    has_many :recipes, Recipebook.Cookbook.Recipe
    has_many :follows, Recipebook.Account.Follow
    has_many :saved_recipe, Recipebook.Account.SavedRecipe
    timestamps()
  end

  @required_fields [:email, :name, :username, :password]
  @available_fields [:id | @required_fields]
  #

  def by_name(query \\ Recipebook.Account.User, name) do
    search = "%#{name}%"
    from(u in query, where: ilike(u.name, ^search))
  end
  def by_username(query \\ Recipebook.Account.User, username) do
    search = "%#{username}%"
    from(u in query, where: ilike(u.username, ^search))
  end

  def create_changeset(params) do
    changeset(%Recipebook.Account.User{}, params)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@required_fields)
    |> put_pass_hash
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  defp put_pass_hash(%Ecto.Changeset{changes:
    %{password: password}} = changeset) do
    change(changeset, add_hash(password, hash_key: :password))
  end
end
