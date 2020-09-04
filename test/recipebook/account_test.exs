defmodule Recipebook.AccountTest do
  use Recipebook.DataCase, async: true
  alias Recipebook.Account
  alias Recipebook.Support.UserSupport
  alias Recipebook.Support.RecipeSupport

  def setup_user(context) do
    {:ok, user} = UserSupport.generate_user
    Map.put(context, :user, user)
  end
  def setup_user_with_password(context) do
    {:ok, user} = UserSupport.generate_user_raw_data
    Map.put(context, :user, user)
  end
  def setup_user_and_following(context) do
    {:ok, user} = UserSupport.generate_users_and_following_chef
    Map.put(context, :user, user)
  end
  def setup_user_and_followers(context) do
    {:ok, user} = UserSupport.generate_users_and_followers
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
    test "return error if not found" , _context do
      assert {:error, _} = Account.find_user(%{username: "aaaaaaaaaaaaaa"})
    end
  end

  describe "&follow_user/2" do
    setup [:setup_user]
    test "successfully follow user if user exist" , context do
      user = context[:user]
      {:ok, followed_user} = UserSupport.generate_user

      assert {:ok, _} = Account.follow_user(user, %{id: followed_user.id})
    end
    test "return error if user does not eixst" , context do
      user = context[:user]
      assert {:error, _} = Account.follow_user( user, %{id: "222244444"})
    end
  end
  describe "&unfollow_user/2" do
    setup [:setup_user]
    test "successfully unfollow user if user exist" , context do
      user = context[:user]
      assert {:ok, followed_user} = UserSupport.generate_user
      assert {:ok, followed_user2} = UserSupport.generate_user
      Account.follow_user(user, %{id: followed_user.id})
      Account.follow_user(user, %{id: followed_user2.id})
      assert {:ok, followers} = Account.get_following(%{id: user.id})
      assert Enum.count(followers) === 2
      assert {:ok, _} = Account.unfollow_user(user, %{id: followed_user.id})
      assert {:ok, followers} = Account.get_following(%{id: user.id})
      assert Enum.count(followers) === 1
    end
  end
  describe "&update_user/3" do
    setup [:setup_user_with_password]
    test "successfully update details user update own account" , context do
      user = context[:user]
      original_email = user.email
      assert {:ok, result} = Account.update_user(user, user.id, %{current_password: user.password, email: "aaaaaa@bbbbb.com"})
      assert {:ok, return_user} = Account.find_user(%{id: user.id})
      assert result.email === "aaaaaa@bbbbb.com"
      assert return_user.email === "aaaaaa@bbbbb.com"
      assert original_email !== "aaaaaa@bbbbb.com"
    end
    test "fail if tried to update someone else's account" , context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user
      assert {:error, _} = Account.update_user(user, another_user.id, %{current_password: user.password, email: "aaaaaa@bbbbb.com"})
    end
  end

  describe "&get_followers/1" do
    setup [:setup_user_and_followers]
    test "successfully get followers and the names", context do
      user = context[:user]
      # Generate another bunch and ensure the length is not the same as the first one
      UserSupport.generate_users_and_followers(4)
      assert {:ok, followers} = Account.get_followers(%{id: user.id})
      assert is_list(followers)
      assert Enum.count(followers) === 10
      [first_user | _the_rest] = followers
      assert first_user.name !== user.name
    end
  end
  describe "&get_following/1" do
    setup [:setup_user_and_following]
    test "successfully get following and the names", context do
      user = context[:user]
      # Generate another bunch and ensure the length is not the same as the first one
      UserSupport.generate_users_and_following_chef(4)
      assert {:ok, following} = Account.get_following(%{id: user.id})
      assert is_list(following)
      assert Enum.count(following) === 10
    end
  end
  describe "&save_recipe/1" do
    setup [:setup_user]
    test "successfully get who the users are following", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()
      {:ok, target_recipe} = RecipeSupport.generate_recipe(another_user)
      assert {:ok, _} = Account.save_recipe(user, %{recipe_id: target_recipe.id})
    end
    test "return error if recipe not found", context do
      user = context[:user]
      assert {:error, message} = Account.save_recipe(user, %{recipe_id: "000011"})
      assert message =~ "no records found"
    end
  end
  describe "&unsave_recipe/1" do
    setup [:setup_user]
    test "succesuffly remove saved recipe", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()
      {:ok, target_recipe} = RecipeSupport.generate_recipe(another_user)
      assert {:ok, _} = Account.save_recipe(user, %{recipe_id: target_recipe.id})
      assert {:ok, recipes} = Account.get_saved_recipes(user)
      assert Enum.count(recipes) === 1
      assert {:ok, _} = Account.unsave_recipe(user, %{recipe_id: target_recipe.id})
      assert {:ok, recipes} = Account.get_saved_recipes(user)
      assert Enum.count(recipes) === 0
    end
  end
  describe "&get_saved_recipes/1" do
    setup [:setup_user]
    test "succesuffly remove saved recipe", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()
      target_recipes = RecipeSupport.generate_recipes(another_user)
      Enum.map(target_recipes, fn {:ok, recipe} -> Account.save_recipe(user, %{recipe_id: recipe.id}) end)
      assert {:ok, recipes} = Account.get_saved_recipes(user)
      assert Enum.count(recipes) === Enum.count(target_recipes)
    end
  end
end
