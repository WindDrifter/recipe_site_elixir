defmodule Recipebook.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

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

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @available_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
