defmodule RecipebookWeb.Context do
  @behaviour Plug
  import Plug.Conn
  import Ecto.Query, only: [where: 2]
  alias Recipebook.{Repo, Account, Cookbook}

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end
  defp authorize(token) do
    Account.find_user()
  end


end
