defmodule RecipebookWeb.UserChannel do
  use RecipebookWeb, :channel

  def join("users", _payload, socket) do
    {:ok, socket}
  end

  def handle_in(id, %{"user_ids" => user_ids}, socket) do
    # this if for update preferences check
    # it will boardcast certain user id update
    if Enum.member?(user_ids, id) do
      broadcast "create_recipe", socket, %{"user_id"=> id}
      {:reply, %{"accepted" => true}, socket}
    end
  end


end
