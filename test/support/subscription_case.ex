defmodule RecipebookWeb.SubcriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use RecipebookWeb.ChannelCase

      use Absinthe.Phoenix.SubscriptionTest,
        schema: RecipebookWeb.Schema

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(RecipebookWeb.UserSocket, %{})
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, %{socket: socket}}
      end
    end
  end
end
