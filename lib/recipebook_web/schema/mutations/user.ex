defmodule RecipebookWeb.Schema.Mutations.User do
  use Absinthe.Schema.Notation
  object :user_mutations do

    field :user_creation, :user do
      arg :name, :string
      arg :email, :string
    end

    field :update_user, :user do
      arg :id, :id
      arg :name, :string
    end
  end

end
