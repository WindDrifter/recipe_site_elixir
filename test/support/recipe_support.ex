defmodule Recipebook.Support.RecipeSupport do
    alias Recipebook.Cookbook
    def generate_recipes do
      for n <- 1..3 do
        Cookbook.create_recipe(%{
          name: "test user #{n}",
          email: Faker.Internet.email(),
          username: Faker.Internet.user_name(),
          password: "123456"
        })
      end
    end
    def generate_user do
      Cookbook.create_recipe(%{
        name: Faker.Food.dish(),
        email: Faker.Internet.email(),
        username: Faker.Internet.user_name(),
        password: "123456"
      })
    end
    def create_unsaved_recipe do
      {:ok, %{
        "name" => Faker.Food.dish(),
        "email" => Faker.Internet.email(),
        "username" => Faker.Internet.user_name(),
        "password" => "123456"
      }}

    end
  end
