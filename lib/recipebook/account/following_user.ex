defmodule Recipebook.Account.FollowingUser do
  use Ecto.Schema
  import Ecto.{Changeset, Query}

  schema "following_users" do
    belongs_to :user, Recipebook.Account.User
    belongs_to :following_user, Recipebook.Account.User
    timestamps()
  end
  def create_changeset(params) do
    changeset(%Recipebook.Account.FollowingUser{}, params)
  end

  def setup_query() do
    from(fou in Recipebook.Account.FollowingUser, as: :following_user)
  end
  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [:user_id, :following_user_id])
    |> validate_required([:user_id, :following_user_id])

  end
end
