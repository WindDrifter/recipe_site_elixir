defmodule RecipebookWeb.Schema.Mutations.UserTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Account
  alias Recipebook.Support.UserSupport
  @create_user_doc """
    mutation CreateUser($username: String, $email: String, $password: String, $name: String){
      createUser(name: $name, username: $username, email: $email, password: $password) {
        id
        username
        name
      }
    }
  """
  @update_user_doc """
    mutation UpdateUser($id: ID, $username: String, $email: String, $name: String){
      UpdateUser(id: $id, name: $name, username: $username, email: $email) {
        id
        username
        name
      }
    }
  """
  @login_user_doc """
  mutation LoginUser($username: String, $password: String){
    loginUser(username: $username, password: $password) {
      token
    }
  }
  """
  @follow_user_doc """
  mutation FollowUser($id: ID){
    followUser(id: $id) {
      token
    }
  }
  """
  def setup_user(context) do
    {_, user} = UserSupport.generate_user
    Map.put(context, :user, user)
  end
  def setup_unsaved_user(context) do
    {_, user} = UserSupport.create_unsaved_user
    Map.put(context, :user, user)
  end
  def setup_user_with_password(context) do
    {_, user} = UserSupport.generate_user_raw_data
    Map.put(context, :user, user)
  end
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
  describe "@loginUser" do
    setup [:setup_user_with_password]
    test "able to login and get password", context do
      user = context[:user]
      assert {:ok, %{data: data}} = Absinthe.run(@login_user_doc, Schema,
        variables: %{"username" => user.username, "password" => user.password}
      )
      assert data["loginUser"]["token"] !== nil
    end
    test "not able to login if wrong password", context do
      user = context[:user]
      {_, user} = Map.pop(user, "email")
      assert {:ok, %{errors: errors}} = Absinthe.run(@login_user_doc, Schema,
        variables: %{"username" => user.username, "password" => "Totally wrong password"}
      )
      assert length(errors) === 1
      assert String.contains?(Map.get(List.first(errors),:message), ["wrong password or invalid username"])
    end
  end
  describe "@updateUser" do
    setup [:setup_user]
    test "able to update user", context do
      user = context[:user]
      assert {:ok, %{data: data}} = Absinthe.run(@update_user_doc, Schema,
        [variables: %{"id" => user.id, "name" => "wololo something"}, context: %{current_user: user}]
      )
      assert {:ok, found_user} = Account.find_user(%{id: user.id})
      assert found_user.name === "wololo something"
    end
    test "not able to create user if an important arg is missing", context do
      user = context[:user]
      assert {:ok, %{errors: errors}} = Absinthe.run(@update_user_doc, Schema,
        [variables: %{"name" => "wololo something"}, context: %{current_user: user}]
      )
      assert length(errors) === 1
      assert String.contains?(Map.get(List.first(errors),:message), ["found null"])
    end
    test "return error if try to edit another user profile", context do
      user = context[:user]
      {_, another_user} = UserSupport.generate_user
      assert {:ok, %{errors: errors}} = Absinthe.run(@update_user_doc, Schema,
        [variables: %{"id" => another_user.id, "name" => "wololo something"}, context: %{current_user: user}]
      )
      assert length(errors) === 1
      assert Map.get(List.first(errors),:message) =~ "do not have permission"
      assert {:ok, found_user} = Account.find_user(%{id: another_user.id})
      assert found_user.name !== "wololo something"
    end
  end
  describe "followUser" do

  end

end
