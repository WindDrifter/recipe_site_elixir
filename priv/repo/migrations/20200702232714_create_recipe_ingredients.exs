defmodule Recipebook.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients) do
      add :amount, :integer
      add :unit, :string
      add :ingredient_id, references(:ingredients, on_delete: :delete_all)
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:recipe_ingredients, [:ingredient_id])
    create index(:recipe_ingredients, [:recipe_id])
  end
end
