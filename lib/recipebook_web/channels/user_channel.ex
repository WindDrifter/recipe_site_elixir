defmodule RecipebookWeb.UserChannel do
  use RecipebookWeb, :channel

  def join("users", _payload, socket) do
    {:ok, socket}
  end
  def handle_in("create_recipe", %{"id" => id}, socket) do
    broadcast "create_recipe", socket, %{"id"=> id}
    {:reply, %{"accepted" => true}, socket}
  end

  def handle_in(id, %{"user_id" => user_id}, socket) do
    # this if for update preferences check
    # it will boardcast certain user id update
    if id === user_id do
      broadcast "update_preferences", socket, %{"user_id"=> user_id}
      {:reply, %{"accepted" => true}, socket}
    end
  end


end
