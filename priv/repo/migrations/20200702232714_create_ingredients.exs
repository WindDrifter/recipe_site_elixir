defmodule Recipebook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :amount, :integer
      add :unit, :string
      add :food_id, references(:foods, on_delete: :delete_all)
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:ingredients, [:food_id])
    create index(:ingredients, [:recipe_id])
  end
end
