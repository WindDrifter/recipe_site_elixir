defmodule RecipebookWeb.Schema.Subscriptions.User do
  use Absinthe.Schema.Notation
  object :user_subscriptions do

    # field :created_user, :user do
    #   trigger :create_user, topic: fn _ ->
    #     "new_user"
    #   end
    #   config fn _, _ ->
    #     {:ok, topic: "new_user"}
    #   end
    # end
    # field :updated_user_preferences, :contract_preferences do
    #   arg :user_id, non_null(:id)
    #   trigger :update_user_preferences, topic: fn value ->
    #     value.user_id
    #   end
    #   config fn args, _ ->
    #     {:ok, topic: args.user_id }
    #   end
    # end
  end
end
