defmodule Recipebook.Repo.Migrations.RemoveTimestampsForSaveRecipeAndFollowingUser do
  use Ecto.Migration

  def change do
    alter table(:following_users) do
      remove :inserted_at
      remove :updated_at
    end

    alter table(:saved_recipes) do
      remove :inserted_at
      remove :updated_at
    end
  end
end
