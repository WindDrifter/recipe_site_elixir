defmodule RecipebookWeb.Schema.Queries.UserTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Support.UserSupport

  @all_users_doc """
    query users($name: String, $username: String, $first: Int){
      users(username: $username, name: $name, first: $first) {
        id
        name
        username
      }
    }
  """
  @get_user_doc """
    query getUser($id: ID, $username: String, $name: String){
      user(id: $id, username: $username, name: $name) {
        id
        name
        username
      }
    }
  """
  def setup_mass_users(_context) do
    UserSupport.generate_users()
    UserSupport.generate_users_with_random_name()
  end

  def setup_user(context) do
    {:ok, user} = UserSupport.generate_user()
    Map.put(context, :user, user)
  end

  describe "@users" do
    setup [:setup_mass_users]

    test "able to get users by name" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@all_users_doc, Schema,
                 variables: %{
                   "name" => "user"
                 }
               )

      assert length(data["users"]) === 10
    end

    test "able to get first n amount" do
      assert {:ok, %{data: data}} =
               Absinthe.run(@all_users_doc, Schema,
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
      id = to_string(user.id)
      assert {:ok, %{data: data}} = Absinthe.run(@get_user_doc, Schema, variables: %{"id" => id})
      assert data["user"]["username"] === user.username
    end

    test "able to get user by name", context do
      user = context[:user]
      username = to_string(user.username)

      assert {:ok, %{data: data}} =
               Absinthe.run(@get_user_doc, Schema, variables: %{"username" => username})

      assert data["user"]["name"] === user.name
    end

    test "return error if no args presents" do
      assert {:ok, %{errors: errors}} = Absinthe.run(@get_user_doc, Schema, variables: %{})
      assert length(errors) === 1
      assert Map.get(List.first(errors), :message) === "must enter at least one params"
    end
  end
end
