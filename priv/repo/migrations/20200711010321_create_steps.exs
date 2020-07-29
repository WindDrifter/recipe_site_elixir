defmodule Recipebook.Repo.Migrations.CreateSteps do
  use Ecto.Migration

  def change do
    create table(:steps) do
      add :instruction, :text
      add :recipe, references(:recipes, on_delete: :nothing)

      timestamps()
    end

    create index(:steps, [:recipe])
  end
end
