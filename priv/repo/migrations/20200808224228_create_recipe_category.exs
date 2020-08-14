defmodule Recipebook.Repo.Migrations.CreateRecipeCategory do
  use Ecto.Migration

  def change do
    create table(:recipe_categories) do
      add :recipe_id, references(:recipes, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps()
    end

    create index(:recipe_categories, [:recipe_id])
    create index(:recipe_categories, [:category_id])
  end
end
