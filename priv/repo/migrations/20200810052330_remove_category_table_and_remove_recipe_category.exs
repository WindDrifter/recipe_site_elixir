defmodule Recipebook.Repo.Migrations.RemoveCategoryTableAndRemoveRecipeCategory do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :categories, {:array, :citext}
    end

    drop table(:recipe_categories)
    drop table(:categories)
  end
end
