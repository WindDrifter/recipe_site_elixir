defmodule RecipebookWeb.Resolvers.User do
    alias Recipebook.Account
  
    def find(%{id: id}, _) do
      id = String.to_integer(id)
      Account.find_user(%{id: id})
    end
  
    def update(%{id: id} = params, _) do
      id = String.to_integer(id)
      Account.update_user(id, Map.delete(params, :id))
    end
  
    def create_user(params, _) do
      Account.create_user(params)
    end

  end