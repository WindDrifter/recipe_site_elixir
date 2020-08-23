defmodule Recipebook.Account.User do
  import Argon2
  import Ecto.{Changeset, Query}
  alias EctoShorts.CommonChanges

  use Ecto.Schema
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string
    field :username, :string
    has_many :recipes, Recipebook.Cookbook.Recipe
    many_to_many :users, Recipebook.Account.User, join_through: Recipebook.Account.FollowingUser, join_keys: [user_id: :id, following_user_id: :id]
    has_many :saved_recipes, Recipebook.Account.SavedRecipe
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


  def find_user_followers(query \\ Recipebook.Account.User, id) do
    where(query, [followed: f], f.id == ^id)
  end

  def join_other_users_as_followers(query \\ Recipebook.Account.User) do
    join(query, :inner, [u], f in assoc(u, :users), as: :followed)
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
    |> CommonChanges.preload_change_assoc(:users)
    |> CommonChanges.preload_change_assoc(:saved_recipes)

  end

  defp put_pass_hash(%Ecto.Changeset{changes:
    %{password: password}} = changeset) do
    change(changeset, add_hash(password, hash_key: :password))
  end

  # For when password parameter does not exist
  defp put_pass_hash(%Ecto.Changeset{changes:
  %{}} = changeset) do
  changeset
end
end
