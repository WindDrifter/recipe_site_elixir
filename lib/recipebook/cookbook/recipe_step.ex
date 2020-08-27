defmodule Recipebook.Cookbook.RecipeStep do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_steps" do
    field :instruction, :string
    field :number, :integer
    belongs_to :recipe, Recipebook.Cookbook.Recipe
    timestamps()
  end

  @required_params [:instruction, :number]
  @all_params [:recipe_id | @required_params]

  @doc false
  def changeset(recipe_step, attrs) do
    recipe_step
    |> cast(attrs, @all_params)
    |> validate_required(@required_params)
  end
end
