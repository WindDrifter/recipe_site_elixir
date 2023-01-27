defmodule RecipebookWeb.Resolvers.Session do
  alias Recipebook.Authentication

  def login_user(params, _) do
    Authentication.login_user(params)
  end
end
