defmodule Recipebook.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  alias Recipebook.ViewStats.RecipeViewCounter
  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Recipebook.Repo,
      # Start the Telemetry supervisor
      RecipebookWeb.Telemetry,
      # Start the PubSub system
      # Start the Endpoint (http/https)
      RecipebookWeb.Endpoint,
      {Phoenix.PubSub, [name: Recipebook.PubSub, adapter: Phoenix.PubSub.PG2]},
      {Absinthe.Subscription, RecipebookWeb.Endpoint},
      {RecipeViewCounter, name: CategoryViewCounter},
      RecipeViewCounter
      # Start a worker by calling: Recipebook.Worker.start_link(arg)
      # {Recipebook.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Recipebook.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RecipebookWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
