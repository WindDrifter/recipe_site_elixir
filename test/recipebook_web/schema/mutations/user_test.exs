defmodule RecipebookWeb.Schema.Mutations.UserTest do
  use Recipebook.DataCase, async: true

  alias RecipebookWeb.Schema
  alias Recipebook.Account
  alias Recipebook.Support.{RecipeSupport, UserSupport}

  @create_user_doc """
    mutation CreateUser($username: String!, $email: String!, $password: String!, $name: String!){
      createUser(name: $name, username: $username, email: $email, password: $password) {
        id
        username
        name
      }
    }
  """
  @update_user_doc """
    mutation UpdateUser($id: ID!, $current_password: String!, $username: String, $email: String, $name: String){
      updateUser(id: $id, current_password: $current_password, name: $name, username: $username, email: $email) {
        id
        username
        name
      }
    }
  """
  @login_user_doc """
  mutation LoginUser($username: String!, $password: String!){
    loginUser(username: $username, password: $password) {
      token
    }
  }
  """
  @follow_user_doc """
  mutation FollowUser($id: ID!){
    followUser(id: $id) {
      message
    }
  }
  """
  @unfollow_user_doc """
  mutation unfollowUser($id: ID!){
    unfollowUser(id: $id) {
      message
    }
  }
  """
  @save_recipe_doc """
  mutation SaveRecipe($recipe_id: ID!){
    saveRecipe(recipe_id: $recipe_id) {
      id
      name
    }
  }
  """
  @unsave_recipe_doc """
  mutation UnsaveRecipe($recipe_id: ID!){
    unsaveRecipe(recipe_id: $recipe_id) {
      message
    }
  }
  """
  def setup_user(context) do
    {:ok, user} = UserSupport.generate_user()
    Map.put(context, :user, user)
  end

  def setup_unsaved_user(context) do
    {:ok, user} = UserSupport.create_unsaved_user()
    Map.put(context, :user, user)
  end

  def setup_user_with_password(context) do
    {:ok, user} = UserSupport.generate_user_raw_data()
    Map.put(context, :user, user)
  end

  describe "@createUser" do
    setup [:setup_unsaved_user]

    test "able to create user", context do
      user = context[:user]
      assert {:ok, %{data: %{"createUser" => result}}} = Absinthe.run(@create_user_doc, Schema, variables: user)
      assert {:ok, found_user} = Account.find_user(%{username: result["username"]})
      assert found_user.name === user["name"]
    end

    test "not able to create user if an important arg is missing", context do
      user = Map.delete(context[:user], "email")
      assert {:ok, %{errors: errors}} = Absinthe.run(@create_user_doc, Schema, variables: user)
      assert String.contains?(Map.get(List.first(errors), :message), ["found null"])
    end
  end

  describe "@loginUser" do
    setup [:setup_user_with_password]

    test "able to login and get password", context do
      user = context[:user]

      assert {:ok, %{data: data}} =
               Absinthe.run(@login_user_doc, Schema,
                 variables: %{"username" => user.username, "password" => user.password}
               )

      assert data["loginUser"]["token"] !== nil
    end

    test "not able to login if wrong password", context do
      user = context[:user]
      {_email, user} = Map.pop(user, "email")

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@login_user_doc, Schema,
                 variables: %{"username" => user.username, "password" => "Totally wrong password"}
               )

      assert length(errors) === 1
      assert Map.get(List.first(errors), :message) =~ "Wrong password or invalid username"
    end
  end

  describe "@updateUser" do
    setup [:setup_user_with_password]

    test "able to update user", context do
      user = context[:user]

      assert {:ok, %{data: %{"updateUser" => result}}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{
                   "current_password" => user.password,
                   "id" => user.id,
                   "name" => "wololo something"
                 },
                 context: %{current_user: user}
               )

      assert {:ok, found_user} = Account.find_user(%{id: user.id})
      assert found_user.name === result["name"]
    end

    test "not able to create user if an important arg is missing", context do
      user = context[:user]

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{"current_password" => user.password, "name" => "wololo something"},
                 context: %{current_user: user}
               )
      assert String.contains?(Map.get(List.first(errors), :message), ["found null"])
    end

    test "return error if try to edit another user profile", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()

      assert {:ok, %{errors: errors}} =
               Absinthe.run(@update_user_doc, Schema,
                 variables: %{
                   "current_password" => user.password,
                   "id" => another_user.id,
                   "name" => "wololo something"
                 },
                 context: %{current_user: user}
               )

      assert length(errors) === 1
      assert Map.get(List.first(errors), :message) =~ "do not have permission"
      assert {:ok, found_user} = Account.find_user(%{id: another_user.id})
      assert found_user.name !== "wololo something"
    end
  end

  describe "@followUser" do
    setup [:setup_user]

    test "able to follow another user", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()

      assert {:ok, data} =
               Absinthe.run(@follow_user_doc, Schema,
                 variables: %{"id" => another_user.id},
                 context: %{current_user: user}
               )

      assert data.data["followUser"]["message"] =~ "Successfully"
    end

    test "return error if user doesn't exist", context do
      user = context[:user]

      assert {:ok, errors} =
               Absinthe.run(@follow_user_doc, Schema,
                 variables: %{"id" => "11111111"},
                 context: %{current_user: user}
               )

      assert Map.get(List.first(errors.errors), :message) =~ "no records found"
    end
  end

  describe "@unfollowUser" do
    setup [:setup_user]

    test "able to follow another user", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.create_an_chef_and_follow(user)

      assert {:ok, data} =
               Absinthe.run(@unfollow_user_doc, Schema,
                 variables: %{"id" => another_user.id},
                 context: %{current_user: user}
               )

      assert data.data["unfollowUser"]["message"] =~ "Successfully unfollow user"
    end
  end

  describe "@saveRecipe" do
    setup [:setup_user]

    test "able to save an recipe", context do
      user = context[:user]
      {:ok, saved_recipes} = Account.get_saved_recipes(user)
      original_count = Enum.count(saved_recipes)
      {:ok, another_user} = UserSupport.generate_user()
      {:ok, recipe} = RecipeSupport.generate_recipe(another_user)

      assert {:ok, data} =
               Absinthe.run(@save_recipe_doc, Schema,
                 variables: %{"recipe_id" => recipe.id},
                 context: %{current_user: user}
               )

      assert {:ok, found_user} = Account.find_user(%{id: user.id})
      {:ok, saved_recipes} = Account.get_saved_recipes(found_user)
      assert Enum.count(saved_recipes) === original_count + 1
      assert data.data["saveRecipe"]["name"] === recipe.name
    end
  end

  describe "@unsaveRecipe" do
    setup [:setup_user]

    test "able to unsave an recipe", context do
      user = context[:user]
      {:ok, another_user} = UserSupport.generate_user()
      {:ok, recipe} = RecipeSupport.generate_recipe(another_user)
      {:ok, _} = Account.save_recipe(user, %{recipe_id: recipe.id})
      {:ok, saved_recipes} = Account.get_saved_recipes(user)
      original_count = Enum.count(saved_recipes)
      assert original_count === 1

      assert {:ok, data} =
               Absinthe.run(@unsave_recipe_doc, Schema,
                 variables: %{"recipe_id" => recipe.id},
                 context: %{current_user: user}
               )

      assert data.data["unsaveRecipe"]["message"] =~ "Successfully unsave"
      {:ok, new_list} = Account.get_saved_recipes(user)
      assert Enum.count(new_list) === original_count - 1
    end
  end
end
