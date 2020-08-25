defmodule RecipebookWeb.Schema.Subscriptions.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_subscriptions do


    field :create_recipe, :recipe do
      arg :user_ids, list_of(non_null(:id))
      trigger :create_recipe, topic: fn value ->
        value.user.id
      end
      config fn args, _ ->
        {:ok, topic: args.user_ids }
      end
    end
  end
end
