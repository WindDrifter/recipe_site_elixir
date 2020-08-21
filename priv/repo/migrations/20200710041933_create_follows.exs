defmodule Recipebook.Repo.Migrations.CreateFollows do
  use Ecto.Migration

  def change do
    create table(:following_users) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :following_user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:following_users, [:user_id])
    create index(:following_users, [:following_user_id])
  end
end
