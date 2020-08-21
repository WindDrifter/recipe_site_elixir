defmodule RecipebookWeb.Resolvers.User do
    alias Recipebook.Account


    def all(params, _) do
      Account.all_users(params)
    end

    def follow_user(params, _, context) do

    end

    def find(%{id: id}, _) do
      id = String.to_integer(id)
      Account.find_user(%{id: id})
    end

    def find(params, _) when params != %{} do
      Account.find_user(params)
    end

    def find(_, _) do
      {:error, "must enter at least one params"}
    end

    def get_users(params, _) do
      Account.all_users(params)
    end

    def update(%{id: id} = params, _) do
      id = String.to_integer(id)
      Account.update_user(id, Map.delete(params, :id))
    end

    def create_user(params, _) do
      Account.create_user(params)
    end

  end
