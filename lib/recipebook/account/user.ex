defmodule Recipebook.Account.User do
  import Argon2
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges
  alias Recipebook.Account.{User}
  alias Recipebook.Cookbook.Recipe

  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :username, :string
    has_many :recipes, Recipe

    many_to_many :following, User,
      join_through: "following_users",
      join_keys: [user_id: :id, following_user_id: :id],
      on_replace: :delete

    many_to_many :followers, User,
      join_through: "following_users",
      join_keys: [following_user_id: :id, user_id: :id]

    many_to_many :saved_recipes, Recipe, join_through: "saved_recipes", on_replace: :delete
    timestamps()
  end

  @required_fields [:email, :name, :username, :password]
  @available_fields [:id | @required_fields]
  #
  def create_changeset(params) do
    changeset(%User{}, params)
  end

  def by_name(query \\ setup_query(), name) do
    search = "%#{name}%"
    from(u in query, where: ilike(u.name, ^search))
  end

  def by_username(query \\ setup_query(), username) do
    search = "%#{username}%"
    from(u in query, where: ilike(u.username, ^search))
  end

  def setup_query() do
    from(u in User, as: :user)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@required_fields)
    |> CommonChanges.preload_change_assoc(:followers)
    |> CommonChanges.preload_change_assoc(:following)
    |> CommonChanges.preload_change_assoc(:saved_recipes)
    |> put_pass_hash
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  defp put_pass_hash(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    change(changeset, add_hash(password, hash_key: :password))
  end

  # For when password parameter does not exist
  defp put_pass_hash(%Ecto.Changeset{changes: %{}} = changeset) do
    changeset
  end
end
