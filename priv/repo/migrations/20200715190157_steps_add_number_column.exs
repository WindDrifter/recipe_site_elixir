defmodule Recipebook.Repo.Migrations.StepsAddNumberColumn do
  use Ecto.Migration

  def change do
    alter table("recipe_steps") do
      add :number, :integer
    end

    create index(:recipe_steps, [:number])
  end
end
