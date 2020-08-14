defmodule Recipebook.CookbookTest do
    use Recipebook.DataCase, async: true

    alias Recipebook.Cookbook

    describe "&create recipe/1" do
      test "able to create recipe" do
        new_recipe = %{name: "test bacon recipes", steps: [
        %{
          number: 1,
          instruction: "heat up pan"
        },
        %{number: 2, instruction: "open bacon packages"}
        ],
        categories: ["comfort food", "breakfast"],
        ingredients: [%{name: "bacon", amount: 5, unit: "strips"}, %{name: "oil", amount: 10, unit: "ml"}]
        }
        assert {:ok, _} = Cookbook.create_recipe(new_recipe)
        assert recipe = Recipebook.Repo.get_by(Cookbook.Recipe, name: "test bacon recipes")
        assert recipe.name === new_recipe[:name]
      end

    end
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
