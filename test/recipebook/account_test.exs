defmodule Recipebook.AccountTest do
  use Recipebook.DataCase, async: true

  alias Recipebook.Account
  alias Recipebook.Support.UserSupport
  def setup_user(context) do
    {_, user} = UserSupport.generate_user(true)
    Map.put(context, :user, user)
  end
  describe "&create user/1" do
    test "able to create user" do
      new_user = %{name: "test user", email: "test@test.com", username: "useruser", password: "12345"}
      assert {:ok, _} = Account.create_user(new_user)
      assert user = Recipebook.Repo.get_by(Account.User, name: "test user")
      assert user.name === new_user[:name]
    end
    test "not able to create user if an important param is missing" do
      new_user = %{name: "test user", password: "assssddd"}
      assert {:error, _} = Account.create_user(new_user)
    end
  end
  describe "&find_user/1" do
    setup [:setup_user]
    test "able to find user" , context do
      user = context[:user]
      assert {:ok, return_user} = Account.find_user(%{username: user.username})
      assert user.name === return_user.name
    end
  end
  describe "&login_user/1" do
    setup [:setup_user]
    test "correct password and return token" , context do
      user = context[:user]
      assert {:ok, id} = Account.login_user(%{username: user.username, password: user.password})
      assert id === user.id
    end
    test "wrong password and return error" , context do
      user = context[:user]
      assert {:error, _} = Account.login_user(%{username: user.username, password: "12345"})
    end
  end


end
