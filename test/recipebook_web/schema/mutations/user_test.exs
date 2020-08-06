defmodule RecipebookWeb.Schema.Mutations.UserTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Account
  alias Recipebook.Support.UserSupport
#   @all_users_doc """
#     query AllUsers($likes_emails: Boolean, $likes_phone_calls: Boolean, $first: Int){
#       users(likesEmails: $likes_emails, likesPhoneCalls: $likes_phone_calls, first: $first) {
#         id
#         name
#         email
#       }
#     }
#   """
  @create_user_doc """
    mutation CreateUser($username: String, $email: String, $password: String, $name: String){
      createUser(name: $name, username: $username, email: $email, password: $password) {
        id
        username
        name
      }
    }
  """
  def setup_mass_users(_context) do
    UserSupport.generate_users
  end
  def setup_user(context) do
    {_, user} = UserSupport.generate_user
    Map.put(context, :user, user)
  end
  def setup_unsaved_user(context) do
    {_, user} = UserSupport.create_unsaved_user
    Map.put(context, :user, user)
  end

#   describe "@users" do
#     setup [:setup_mass_users]
#     test "able to get users by preferences" do
#       assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
#       variables: %{
#         "likes_phone_calls" => false
#         }
#       )
#       assert length(data["users"]) === 3
#     end

#     test "able to get first n amount" do
#       assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
#       variables: %{
#         "first" => 2
#         }
#       )
#       assert length(data["users"]) === 2
#     end
#   end

  describe "@createUser" do
    setup [:setup_unsaved_user]
    test "able to create user", context do
      user = context[:user]
      assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc, Schema,
        variables: user
      )
      assert {:ok, found_user} = Account.find_user(%{username: user["username"]})
      assert found_user.name === user["name"]
    end
    test "not able to create user if an important arg is missing", context do
      user = context[:user]
      {_, user} = Map.pop(user, "email")
      assert {:ok, %{errors: errors}} = Absinthe.run(@create_user_doc, Schema,
        variables: user
      )
      assert length(errors) === 1
      assert String.contains?(Map.get(List.first(errors),:message), ["found null"])
    end
  end
  describe "@updateUser" do
    setup [:setup_user]
    test "able to create user", context do
      user = context[:user]
      assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc, Schema,
        variables: user
      )
      assert {:ok, found_user} = Account.find_user(%{username: user["username"]})
      assert found_user.name === user["name"]
    end
    test "not able to create user if an important arg is missing", context do
      user = context[:user]
      {_, user} = Map.pop(user, "email")
      assert {:ok, %{errors: errors}} = Absinthe.run(@create_user_doc, Schema,
        variables: user
      )
      assert length(errors) === 1
      assert String.contains?(Map.get(List.first(errors),:message), ["found null"])
    end
  end

end
