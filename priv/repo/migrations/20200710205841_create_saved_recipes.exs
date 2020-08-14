defmodule Recipebook.Repo.Migrations.CreateSavedRecipes do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add :user, references(:users, on_delete: :delete_all)
      add :recipe, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:saved_recipes, [:user])
    create index(:saved_recipes, [:recipe])
  end
end
