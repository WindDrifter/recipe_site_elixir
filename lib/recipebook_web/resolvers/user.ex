defmodule RecipebookWeb.Resolvers.User do
    alias Recipebook.Account


    def all(params, _) do
      Account.all_users(params)
    end

    def follow_user(_, params,  %{context: %{current_user: current_user}}) do
      Account.follow_user(current_user, params)
    end

    def unfollow_user(_, params,  %{context: %{current_user: current_user}}) do
      Account.unfollow_user(current_user, params)
    end

    def get_followers(params, _) do
      Account.get_followers(params)
    end

    def get_following(params, _) do
      Account.get_following(params)
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

    def update_user(_, %{id: id} = params, %{context: %{current_user: current_user}}) do
      id = String.to_integer(id)
      Account.update_user(current_user, id, Map.delete(params, :id))
    end

    def get_saved_recipes(_, _,  %{context: %{current_user: current_user}}) do
      Account.get_saved_recipes(current_user)
    end

    def create_user(params, _) do
      Account.create_user(params)
    end

    def login_user(params, _) do
      Account.login_user(params)
    end

  end
