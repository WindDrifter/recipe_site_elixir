defmodule Recipebook.CookbookTest do
    use Recipebook.DataCase, async: true
  
    alias Recipebook.Cookbook
    alias Recipebook.Support.RecipeSupport
  
    # describe "&create user/1" do
    #   test "able to create user" do
    #     new_user = %{name: "test user", email: "test@test.com", username: "useruser", password: "12345"}
    #     assert {:ok, _} = Account.create_user(new_user)
    #     assert user = Recipebook.Repo.get_by(Account.User, name: "test user")
    #     assert user.name === new_user[:name]
    #   end
    #   test "not able to create user if an important param is missing" do
    #     new_user = %{name: "test user"}
    #     assert {:error, _} = Account.create_user(new_user)
    #   end
    # end
    # describe "&find_user/1" do
    #   test "able to find user" do
    #     new_user = %{name: "test user", email: "test@test.com", username: "useruser", password: "12345"}
    #     assert {:ok, _} = Account.create_user(new_user)
    #     assert {:ok, user} = Account.find_user(%{name: "test user"})
    #     assert user.name === new_user[:name]
    #   end
    # end
    # describe "&login_user/1" do
    #   test "correct password and return token" do
    #     new_user = %{name: "test user", email: "test@test.com", password: "password", username: "useruser"}
    #     assert {:ok, _} = Account.create_user(new_user)
    #     assert {:ok, _} = Account.login_user(%{email: "test@test.com", password: "password"})
  
    #   end
    # end
  
  
  end
  