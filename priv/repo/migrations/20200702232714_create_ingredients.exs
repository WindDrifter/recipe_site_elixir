defmodule Recipebook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :amount, :integer
      add :unit, :string
      add :food_id, references(:foods, on_delete: :nothing)
      add :recipe_id, references(:recipes, on_delete: :nothing)

      timestamps()
    end

    create index(:ingredients, [:food_id])
    create index(:ingredients, [:recipe_id])
  end
end
