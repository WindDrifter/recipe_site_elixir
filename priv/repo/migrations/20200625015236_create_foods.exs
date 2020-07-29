defmodule Recipebook.Repo.Migrations.CreateFoods do
  use Ecto.Migration

  def change do
    create table(:foods) do
      add :name, :citext
      add :info, :text
      add :wiki_url, :text

      timestamps()
    end

    create unique_index(:foods, [:name])
  end
end
