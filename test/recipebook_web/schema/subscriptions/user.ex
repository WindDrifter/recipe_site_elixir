defmodule RecipebookWeb.Schema.Subscriptions.UserTest do
  use RecipebookWeb.SubcriptionCase
  use Recipebook.DataCase
  alias Recipebook.Support.UserSupport
  @create_recipe_doc """
    mutation CreateRecipe($name: String, $email: String, $preference: ContractPreferencesInput){
      createUser(name: $name, email: $email, preference: $preference) {
        id
        name
        email
      }
    }
  """

  @create_user_subscription_doc """
  subscription CreateRecipe{
    createRecipe{
      id
      name
      email
    }
  }
  """

  @update_user_pref_subs_doc """
    subscription UserRecipeCreated($user_ids: list_of(ID!)){
    updatedUserPreferences(userIds: $user_ids){
      userIds
      likesEmails
    }
  }
  """

  @update_user_pref_doc """
    mutation UpdateUserPreference($user_id: ID!, $likes_emails: Boolean, $likes_phone_calls: Boolean){
      updateUserPreferences(userId: $user_id, likesEmails: $likes_emails, likesPhoneCalls: $likes_phone_calls) {
        userId
        likesEmails
      }
    }
  """

  # describe "@create_user_subscription" do
  #   test "sends a user when updating user pref mutation is triggered", %{
  #     socket: socket
  #   } do
  #     ref = push_doc socket, @create_user_subscription_doc
  #     assert_reply ref, :ok, %{subscriptionId: subscription_id}
  #     ref = push_doc socket, @create_user_doc, variables: %{
  #       "name" => "random user",
  #       "email" => "random_user@email.com",
  #       "preference" => %{
  #         likes_emails: true,
  #         likes_phone_calls: false
  #       }
  #     }
  #     assert_reply ref, :ok, reply
  #     assert %{data: %{"createUser" => %{
  #       "id" => id,
  #       "name" => name,
  #       "email" => email,
  #     }}} = reply

  #     assert_push "subscription:data", data
  #     assert %{
  #       subscriptionId: ^subscription_id,
  #       result: %{
  #         data:  %{"createdUser" => %{
  #           "id" => ^id,
  #           "name" => ^name,
  #           "email" => ^email
  #           }
  #         }
  #       }
  #     } = data
  #   end
  # end

  # describe "@update_user_pref_subscription" do
  #   test "sends a user when updating user pref mutation is triggered", %{
  #     socket: socket
  #   } do
  #     assert {:ok, user} = UserSupport.generate_user
  #     user_id = to_string(user.id)
  #     ref = push_doc socket, @update_user_pref_subs_doc, variables: %{"user_id"=> user.id}
  #     assert_reply ref, :ok, %{subscriptionId: subscription_id}
  #     ref = push_doc socket, @update_user_pref_doc, variables: %{
  #       "user_id" => user.id,
  #       "likes_emails"=> true,
  #       "likes_phone_calls" => true
  #     }
  #     assert_reply ref, :ok, reply
  #     assert %{data: %{"updateUserPreferences" => %{
  #       "userId" => ^user_id,
  #       "likesEmails"=> true
  #     }}} = reply

  #     assert_push "subscription:data", data
  #     assert %{
  #       subscriptionId: ^subscription_id,
  #       result: %{
  #         data:  %{"updatedUserPreferences" => %{
  #           "userId" => ^user_id,
  #           "likesEmails" => true
  #           }
  #         }
  #       }
  #     } = data
  #   end
  # end

end
