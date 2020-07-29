defmodule PhonebookWeb.Schema.Queries.UserTest do
  use Phonebook.DataCase, async: true

  alias PhonebookWeb.Schema
  alias Phonebook.Support.UserSupport
  @all_users_doc """
    query AllUsers($likes_emails: Boolean, $likes_phone_calls: Boolean, $first: Int){
      users(likesEmails: $likes_emails, likesPhoneCalls: $likes_phone_calls, first: $first) {
        id
        name
        email
      }
    }
  """
  @get_user_doc """
    query getUser($id: ID){
      user(id: $id) {
        id
        name
        email
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

  describe "@users" do
    setup [:setup_mass_users]
    test "able to get users by preferences" do
      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
      variables: %{
        "likes_phone_calls" => false
        }
      )
      assert length(data["users"]) === 3
    end

    test "able to get first n amount" do
      assert {:ok, %{data: data}} = Absinthe.run(@all_users_doc, Schema,
      variables: %{
        "first" => 2
        }
      )
      assert length(data["users"]) === 2
    end
  end

  describe "@user" do
    setup [:setup_user]
    test "able to get user by id", context do
      user = context[:user]
      id = to_string user.id
      assert {:ok, %{data: data}} = Absinthe.run(@get_user_doc, Schema,
        variables: %{"id"=> id}
      )
      assert data["user"]["name"] === user.name
    end
    test "return errors if id is missing" do
      assert {:ok, %{errors: errors}} = Absinthe.run(@get_user_doc, Schema,
      variables: %{}
      )
      assert length(errors) === 1
      assert String.contains?(Map.get(List.first(errors),:message), ["found null"])
    end
  end

end
