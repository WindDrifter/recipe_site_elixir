defmodule RecipebookWeb.Schema do
  use Absinthe.Schema

  import_types RecipebookWeb.Types.User
  import_types RecipebookWeb.Types.Stat
  import_types RecipebookWeb.Schema.Queries.Stat
  import_types RecipebookWeb.Schema.Queries.User
  import_types RecipebookWeb.Schema.Mutations.User
  # import_types RecipebookWeb.Schema.Subscriptions.User

  query do
    import_fields :user_queries
    import_fields :stat_queries
  end

  mutation do
    import_fields :user_mutations
  end

  # subscription do
  #   import_fields :user_subscriptions
  # end

  def context(ctx) do
    source = Dataloader.Ecto.new(Recipebook.Repo)
    dataloader = Dataloader.add_source(Dataloader.new(), Recipebook.Account, source)

    Map.put(ctx, :loader, dataloader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
