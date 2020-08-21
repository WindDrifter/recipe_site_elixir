defmodule Recipebook.Cookbook.Step do
  use Ecto.Schema
  import Ecto.Changeset

  schema "steps" do
    field :instruction, :string
    field :number, :integer
    belongs_to :recipe, Recipebook.Cookbook.Recipe
    timestamps()
  end

  @required_params [:instruction, :number]
  @all_params [:recipe_id | @required_params]

  @doc false
  def changeset(step, attrs) do
    step
    |> cast(attrs, @all_params)
    |> validate_required(@required_params)
  end
end
