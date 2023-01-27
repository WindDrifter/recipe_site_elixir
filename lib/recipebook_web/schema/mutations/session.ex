defmodule RecipebookWeb.Schema.Mutations.Session do
  use Absinthe.Schema.Notation

  object :session_mutations do
    field :login_user, :session do
      arg(:username, :string)
      arg(:password, :string)
      resolve(&RecipebookWeb.Resolvers.Session.login_user/2)
    end
  end
end
