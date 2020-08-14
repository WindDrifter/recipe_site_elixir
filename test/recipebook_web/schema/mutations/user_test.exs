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
  # @update_user_doc """
  #   mutation UpdateUser($id: !ID, $username: String, $email: String, $name: String){
  #     UpdateUser(id: $id, name: $name, username: $username, email: $email) {
  #       id
  #       username
  #       name
  #     }
  #   }
  # """
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
  # describe "@updateUser" do
  #   setup [:setup_user]
  #   test "able to create user", context do
  #     user = context[:user]
  #     assert {:ok, %{data: data}} = Absinthe.run(@create_user_doc, Schema,
  #       variables: user
  #     )
  #     assert {:ok, found_user} = Account.find_user(%{username: user["username"]})
  #     assert found_user.name === user["name"]
  #   end
  #   test "not able to create user if an important arg is missing", context do
  #     user = context[:user]
  #     {_, user} = Map.pop(user, "email")
  #     assert {:ok, %{errors: errors}} = Absinthe.run(@create_user_doc, Schema,
  #       variables: user
  #     )
  #     assert length(errors) === 1
  #     assert String.contains?(Map.get(List.first(errors),:message), ["found null"])
  #   end
  # end

end
