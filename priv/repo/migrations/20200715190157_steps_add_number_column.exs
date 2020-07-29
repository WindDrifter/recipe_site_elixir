defmodule Recipebook.Repo.Migrations.StepsAddNumberColumn do
  use Ecto.Migration

  def change do
    alter table("steps") do
      add :number, :integer
    end
    create index(:steps, [:number])

  end
end
