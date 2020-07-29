defmodule Recipebook.Account.Follow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "follows" do
    field :user, :id
    field :follow, :id

    timestamps()
  end

  @doc false
  def changeset(follow, attrs) do
    follow
    |> cast(attrs, [])
    |> validate_required([])
  end
end
