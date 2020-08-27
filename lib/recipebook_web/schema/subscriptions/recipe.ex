defmodule RecipebookWeb.Schema.Subscriptions.Recipe do
  use Absinthe.Schema.Notation
  object :recipe_subscriptions do
    @desc "For user to track when a chef they followed create a recipe"
    field :create_recipe, :recipe do
      arg :user_ids, list_of(non_null(:id))
      trigger :create_recipe, topic: fn value ->
        value.user.id
      end
      config &RecipebookWeb.Resolvers.Recipe.create_recipe_topic/2
    end
  end
end
