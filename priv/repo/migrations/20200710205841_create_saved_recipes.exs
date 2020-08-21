defmodule Recipebook.Repo.Migrations.CreateSavedRecipes do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:saved_recipes, [:user_id])
    create index(:saved_recipes, [:recipe_id])
  end
end
