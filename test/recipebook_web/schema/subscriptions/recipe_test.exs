defmodule RecipebookWeb.Schema.Subscriptions.RecipeTest do
  use Recipebook.DataCase
  use RecipebookWeb.SubcriptionCase
  alias RecipebookWeb.Schema
  alias Recipebook.Support.UserSupport
  alias Recipebook.Support.RecipeSupport

  @create_recipe_doc """
  mutation CreateRecipe($name: String, $steps: [InputStep], $ingredients: [InputIngredient], $categories: [String]){
    createRecipe(name: $name, categories: $categories, steps: $steps, ingredients: $ingredients) {
      id
      name
      categories
      user{
        name
        id
      }
    }
  }
"""

  @recipe_create_subs_doc """
    subscription CreateRecipe($user_ids: [ID!]){
      createRecipe(userIds: $user_ids){
      name
      user{
        name
        id
      }
    }
  }
  """

  describe "@recipe_creation_subscription" do
    test "sends an recipe when one of the user ids create the recipe", %{
      socket: socket
    } do
      {:ok, user} = UserSupport.generate_user
      {:ok, user2} = UserSupport.generate_user
      user_name = user.name
      user_id = to_string(user.id)
      recipe_raw_data = RecipeSupport.generate_raw_recipe
      name = recipe_raw_data["name"]
      ref = push_doc socket, @recipe_create_subs_doc, variables: %{"user_ids"=> [user.id, user2.id]}
      assert_reply ref, :ok, %{subscriptionId: subscription_id}
      assert {:ok, _} = Absinthe.run(@create_recipe_doc, Schema,
      [variables: recipe_raw_data, context: %{current_user: user, pubsub: RecipebookWeb.Endpoint}])

      assert_push "subscription:data", data
      assert %{
        subscriptionId: ^subscription_id,
        result: %{
          data:  %{"createRecipe" => %{
              "user" => %{
                "name" => ^user_name,
                "id" => ^user_id
              },
              "name" => ^name
            }
          }
        }
      } = data
    end
  end

end
