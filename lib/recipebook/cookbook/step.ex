defmodule Recipebook.Cookbook.Step do
  use Ecto.Schema
  import Ecto.Changeset

  schema "steps" do
    field :instruction, :string
    field :number, :integer
    belongs_to :recipe, Recipebook.Cookbook.Recipe
    timestamps()
  end

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, [:instruction])
    |> validate_required([:instruction])
  end
end
