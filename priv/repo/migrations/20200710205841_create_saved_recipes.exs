defmodule Recipebook.Repo.Migrations.CreateSavedRecipes do
  use Ecto.Migration

  def change do
    create table(:saved_recipes) do
      add :user, references(:users, on_delete: :nothing)
      add :recipe, references(:recipes, on_delete: :nothing)

      timestamps()
    end

    create index(:saved_recipes, [:user])
    create index(:saved_recipes, [:recipe])
  end
end
