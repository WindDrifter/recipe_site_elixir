defmodule Recipebook.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:recipe_steps) do
      add :instruction, :text
      add :recipe_id, references(:recipes, on_delete: :delete_all)

      timestamps()
    end

    create index(:recipe_steps, [:recipe_id])
  end
end
