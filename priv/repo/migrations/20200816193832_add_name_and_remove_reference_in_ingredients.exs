defmodule Recipebook.Repo.Migrations.AddNameAndRemoveReferenceInIngredients do
  use Ecto.Migration

  def change do
    drop_if_exists index(:ingredients, [:food_id])
    alter table(:ingredients) do
      add :name, :citext
      remove :food_id
    end
  end
end
