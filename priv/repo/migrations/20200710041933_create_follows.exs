defmodule Recipebook.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:follows) do
      add :user, references(:users, on_delete: :nothing)
      add :follow, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:follows, [:user])
    create index(:follows, [:follow])
  end
end
