defmodule Recipebook.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :citext
      add :info, :text
      add :wiki_url, :text

      timestamps()
    end

    create unique_index(:ingredients, [:name])
  end
end
