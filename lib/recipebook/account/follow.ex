defmodule Recipebook.Account.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    belongs_to :user, Recipebook.Account.User
    belongs_to :follow, Recipebook.Account.User
    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
  end
end
