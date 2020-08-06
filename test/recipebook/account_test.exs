defmodule Recipebook.AccountTest do
  use Recipebook.DataCase, async: true

  alias Recipebook.Account
  alias Recipebook.Support.UserSupport

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
    test "able to find user" do
      new_user = %{name: "test user", email: "test@test.com", username: "useruser", password: "12345"}
      assert {:ok, _} = Account.create_user(new_user)
      assert {:ok, user} = Account.find_user(%{name: "test user"})
      assert user.name === new_user[:name]
    end
  end
  describe "&login_user/1" do
    test "correct password and return token" do
      new_user = %{name: "test user", email: "test2@test.com", password: "password2", username: "useruser34"}
      assert {:ok, user} = Account.create_user(new_user)
      
      assert {:ok, id} = Account.login_user(%{username: "useruser34", password: "password2"})
      assert id === user.id
    end
  end


end
