defmodule RecipebookWeb.Schema.Mutations.RecipeTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Support.UserSupport


  def setup_user(context) do
    {_, user} = UserSupport.generate_user
    Map.put(context, :user, user)
  end

  # Absinthe.run(document, MyAppWeb.Schema, context: %{current_user: %{id: "1"}})
  # context: %{current_user: %{id: "1"}}



end
